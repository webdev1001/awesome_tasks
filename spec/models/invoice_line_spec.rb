require "spec_helper"

describe InvoiceLine do
  let!(:invoice){ create :invoice }
  let!(:invoice_line){ create :invoice_line, invoice: invoice }

  it "should update the invoice price when changing an invoice line" do
    invoice_line.amount = 50.0
    invoice_line.save!

    invoice.reload.amount.should eq 50.0
  end
end
