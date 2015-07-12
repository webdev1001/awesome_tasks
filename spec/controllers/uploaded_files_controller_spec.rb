require "spec_helper"

describe UploadedFilesController do
  let(:invoice){ create :invoice }
  let(:uploaded_file){ create :uploaded_file, resource: invoice }
  let(:user_admin){ create :user_admin }

  render_views

  context "when signed in" do
    before do
      sign_in user_admin
    end

    it "#show" do
      get :show, id: uploaded_file.id
      expect(response).to be_success
    end

    it 'renders show as mobile' do
      get :show, id: uploaded_file.id, mobile: 1
      expect(response).to be_success
    end

    it "#new" do
      get :new
      expect(response).to be_success
    end

    it 'renders new as mobile' do
      get :new, mobile: 1
      expect(response).to be_success
    end

    describe "#create" do
      it "accepts jpeg files" do
        post :create, uploaded_file: {resource_type: "Invoice", resource_id: invoice.id, title: "Test", file: fixture_file_upload(Rails.root.join("spec", "images", "kaspernj.jpg"), "image/jpeg")}
        controller.flash.to_a.should eq []
        new_uploaded_file = UploadedFile.last
        new_uploaded_file.should_not eq nil
        response.should redirect_to invoice
      end

      it "accepts pdf files" do
        post :create, uploaded_file: {resource_type: "Invoice", resource_id: invoice.id, title: "Test", file: fixture_file_upload(Rails.root.join("spec", "images", "test.pdf"), "application/pdf")}
        controller.flash.to_a.should eq []
        new_uploaded_file = UploadedFile.last
        new_uploaded_file.should_not eq nil
        response.should redirect_to invoice
      end
    end

    it "#edit" do
      get :edit, id: uploaded_file.id
      expect(response).to be_success
    end

    it 'renders edit as mobile' do
      get :edit, id: uploaded_file.id, mobile: 1
      expect(response).to be_success
    end

    it "#update" do
      patch :update, id: uploaded_file.id, uploaded_file: {title: "Test test"}
      response.should redirect_to invoice
    end

    it "#destroy" do
      delete :destroy, id: uploaded_file.id
      response.location.should eq invoice_url(invoice)
    end

    it "#index" do
      uploaded_file
      get :index
      expect(response).to be_success
      assigns(:uploaded_files).should include uploaded_file
    end

    it 'renders index as mobile' do
      uploaded_file
      get :index, mobile: 1
      expect(response).to be_success
      expect(assigns(:uploaded_files)).to eq [uploaded_file]
    end
  end
end
