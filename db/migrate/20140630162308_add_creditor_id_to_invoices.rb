class AddCreditorIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :creditor_id, :integer
    add_index :invoices, :creditor_id
  end
end
