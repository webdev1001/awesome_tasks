require "spec_helper"

describe InvoiceLinesController do
  let(:invoice_line){ create :invoice_line, invoice: invoice }
  let(:invoice){ create :invoice }
  let(:user_admin){ create :user_admin }
  let(:valid_attributes){ {title: Forgery::LoremIpsum.words(4), quantity: 2, amount: 50.50} }

  render_views

  context "when signed in as admin" do
    before do
      sign_in user_admin
    end

    it "#new" do
      get :new, invoice_id: invoice.id
      response.should be_success
    end

    it "#create" do
      post :create, invoice_id: invoice.id, invoice_line: valid_attributes
      response.should redirect_to(InvoiceLine.last.invoice)
    end

    it "#edit" do
      get :edit, invoice_id: invoice.id, id: invoice_line.id
      response.should be_success
    end

    it "#update" do
      patch :update, invoice_id: invoice.id, id: invoice_line.id, invoice_line: valid_attributes
      response.should redirect_to(invoice)
    end

    it "#destroy" do
      delete :destroy, invoice_id: invoice.id, id: invoice_line.id
      response.should redirect_to(invoice)
    end
  end
end
