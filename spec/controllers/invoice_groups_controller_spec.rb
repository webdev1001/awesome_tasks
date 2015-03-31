require "spec_helper"

describe InvoiceGroupsController do
  let(:user_admin) { create :user_admin }
  let(:invoice_group) { create :invoice_group }

  render_views

  context "when logged in" do
    before do
      sign_in user_admin
    end

    it "#index" do
      get :index
      response.should be_success
    end

    it "#new" do
      get :new
      response.should be_success
    end

    it "#create" do
      post :create, invoice_group: {name: "Test name"}
      latest_group = InvoiceGroup.last
      response.should redirect_to latest_group
      latest_group.name.should eq "Test name"
    end

    it "#edit" do
      get :edit, id: invoice_group.id
      response.should be_success
    end

    it "#update" do
      patch :update, id: invoice_group.id, invoice_group: {name: "New name"}
      response.should redirect_to(invoice_group)
      invoice_group.reload.name.should eq "New name"
    end

    it "#destroy" do
      delete :destroy, id: invoice_group.id
      response.should redirect_to(invoice_groups_url)
    end
  end
end
