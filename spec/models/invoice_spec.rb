require "spec_helper"

describe Invoice do
  context "#amount_vat" do
    let(:invoice_with_vat) { create :invoice, amount: 100 }
    let(:invoice_without_vat) { create :invoice, amount: 100, no_vat: true }

    it "calculates vat for invoices" do
      invoice_with_vat.amount_vat.should eq 25.0
      invoice_without_vat.amount_vat.should eq 0.0
    end
  end

  context "#filename" do
    let(:invoice_with_invoice_no) { create :invoice, invoice_no: 123 }
    let(:invoice_without_invoice_no) { create :invoice, invoice_no: nil }

    it "uses invoice_no when present" do
      invoice_with_invoice_no.filename.should eq "Invoice 123.pdf"
    end

    it "uses id otherwise" do
      invoice_without_invoice_no.filename.should eq "Invoice ID #{invoice_without_invoice_no.id}.pdf"
    end
  end

  context "#before_validation_set_price_if_not_given" do
    let(:invoice) { build :invoice, amount: nil }

    it "should set a default amount of 0.0" do
      invoice.valid?
      invoice.errors.to_a.should eq []
    end
  end

  context "#add_uninvoiced_timelogs_for_user" do
    let!(:organization) { create :organization }
    let!(:project) { create :project, organization: organization }
    let!(:task) { create :task, project: project }
    let!(:invoice) { create :invoice, organization: organization }
    let!(:timelog) { create :timelog, task: task }
    let!(:user) { create :user }
    let!(:other_timelog) { create :timelog }

    it "adds timelogs" do
      invoice.add_uninvoiced_timelogs_for_user(user)

      timelog.reload
      timelog.invoiced.should eq true
      timelog.invoiced_by_user.should eq user

      other_timelog.reload
      other_timelog.invoiced.should_not eq true
    end
  end
end
