require "spec_helper"

describe Invoice do
  context "#amount_vat" do
    let(:invoice_with_vat){ create :invoice, amount: 100 }
    let(:invoice_without_vat){ create :invoice, amount: 100, no_vat: true }

    it "calculates vat for invoices" do
      invoice_with_vat.amount_vat.should eq 25.0
      invoice_without_vat.amount_vat.should eq 0.0
    end
  end
end
