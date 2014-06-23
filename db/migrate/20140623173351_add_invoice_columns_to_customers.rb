class AddInvoiceColumnsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :email, :string
    
    add_column :customers, :delivery_address, :string
    add_column :customers, :delivery_zip_code, :string
    add_column :customers, :delivery_city, :string
    add_column :customers, :delivery_country, :string
    
    add_column :customers, :invoice_address, :string
    add_column :customers, :invoice_zip_code, :string
    add_column :customers, :invoice_city, :string
    add_column :customers, :invoice_country, :string
  end
end
