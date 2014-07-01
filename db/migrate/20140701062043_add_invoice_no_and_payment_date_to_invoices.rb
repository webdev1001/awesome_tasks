class AddInvoiceNoAndPaymentDateToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_no, :string, :after => :date
    add_column :invoices, :payment_at, :date, :after => :user_id
    add_index :invoices, :invoice_no
  end
end
