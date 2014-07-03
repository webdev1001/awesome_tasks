class AddInvoiceColumnsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :email, :string
    add_column :organizations, :vat_no, :string
    
    add_column :organizations, :delivery_address, :string
    add_column :organizations, :delivery_zip_code, :string
    add_column :organizations, :delivery_city, :string
    add_column :organizations, :delivery_country, :string
    
    add_column :organizations, :invoice_address, :string
    add_column :organizations, :invoice_zip_code, :string
    add_column :organizations, :invoice_city, :string
    add_column :organizations, :invoice_country, :string
  end
end
