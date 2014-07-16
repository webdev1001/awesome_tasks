class AddInvoiceGroupIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_group_id, :integer
    add_index :invoices, :invoice_group_id
  end
end
