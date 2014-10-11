class AddStateToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :state, :string
    add_index :invoices, :state
  end
end
