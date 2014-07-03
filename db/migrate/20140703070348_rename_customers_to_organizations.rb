class RenameCustomersToOrganizations < ActiveRecord::Migration
  def change
    rename_table :customers, :organizations
    rename_column :projects, :customer_id, :organization_id
    rename_column :invoices, :customer_id, :organization_id
  end
end
