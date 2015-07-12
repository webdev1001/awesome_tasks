require "spec_helper"

describe InvoicesController do
  let(:invoice) { create :invoice }
  let(:admin) { create :user_admin }
  let(:invoice_group_1) { create :invoice_group }
  let(:invoice_group_2) { create :invoice_group }
  let(:invoice_group_3) { create :invoice_group }
  let(:valid_params) { {invoice_no: "123456", date: "2014-06-17", invoice_type: "debit", invoice_group_ids: [invoice_group_1.id, invoice_group_3.id]} }

  before do
    sign_in admin
  end

  render_views

  it "#show" do
    get :show, id: invoice.id
    response.should be_success
  end

  it "#index" do
    invoice
    get :index
    response.should be_success
  end

  it "#destroy" do
    delete :destroy, id: invoice.id
    controller.flash[:error].should eq nil
    response.should redirect_to(invoices_url)
  end

  it "#edit" do
    get :edit, id: invoice.id
    response.should be_success
  end

  it "#update" do
    post :update, id: invoice.id, invoice: valid_params

    updated_invoice = assigns(:invoice)
    updated_invoice.should be_valid
    updated_invoice.invoice_groups.should eq [invoice_group_1, invoice_group_3]

    response.should redirect_to invoice_url(updated_invoice)
  end

  it "#new" do
    get :new
    response.should be_success
  end

  it "#create" do
    post :create, invoice: valid_params

    created_invoice = assigns(:invoice)
    created_invoice.should be_valid
    created_invoice.invoice_groups.should eq [invoice_group_1, invoice_group_3]

    response.should redirect_to invoice_url(created_invoice)
  end

  it "#pdf" do
    request.env["HTTP_REFERER"] = root_url
    get :pdf, id: invoice.id
    controller.flash.to_a.should eq []
    response.should be_success
    response.headers["Content-Type"].should eq "application/pdf"
    response.headers["Content-Disposition"].should eq "inline; filename=\"Invoice #{invoice.invoice_no}.pdf\""
  end

  it "#finish" do
    post :finish, id: invoice.id
    response.should redirect_to invoice
    invoice.reload
    invoice.state.should eq "finished"
  end

  it "#register_as_sent" do
    post :register_as_sent, id: invoice.id
    response.should redirect_to invoice
    invoice.reload
    invoice.state.should eq "sent"
  end

  it "#register_as_paid" do
    post :register_as_paid, id: invoice.id
    response.should redirect_to invoice
    invoice.reload
    invoice.state.should eq "paid"
  end
end
