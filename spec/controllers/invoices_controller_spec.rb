require "spec_helper"

describe InvoicesController do
  let(:invoice){ create :invoice }
  let(:admin){ create :user_admin }

  before do
    sign_in admin
  end

  render_views

  it "#show" do
    get :show, id: invoice.id
    response.should be_success
  end

  it "#edit" do
    invoice
    get :index
    response.should be_success
  end

  it "#destroy" do
    delete :destroy, id: invoice.id
    controller.flash[:error].should eq nil
    response.location.should eq invoices_url
  end

  it "#edit" do
    get :edit, id: invoice.id
    response.should be_success
  end

  it "#update" do
    post :update, id: invoice.id, invoice: {title: "Test"}
    assigns(:invoice).valid?.should eq true
    response.location.should eq invoice_url(invoice)
  end

  it "#pdf" do
    request.env["HTTP_REFERER"] = root_url
    get :pdf, id: invoice.id
    controller.flash.to_a.should eq []
    response.should be_success
    response.headers["Content-Type"].should eq "application/pdf"
    response.headers["Content-Disposition"].should eq "inline; filename=\"Invoice #{invoice.id}.pdf\""
  end
end
