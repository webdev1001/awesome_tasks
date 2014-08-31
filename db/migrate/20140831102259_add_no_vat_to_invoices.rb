class AddNoVatToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :no_vat, :boolean
  end
end
