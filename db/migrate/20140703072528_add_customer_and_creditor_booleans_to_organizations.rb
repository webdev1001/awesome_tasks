class AddCustomerAndCreditorBooleansToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :customer, :boolean
    add_column :organizations, :creditor, :boolean
    add_index :organizations, :customer
    add_index :organizations, :creditor
  end
end
