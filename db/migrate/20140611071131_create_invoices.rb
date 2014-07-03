class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :title
      t.date :date
      t.string :invoice_type
      t.float :amount
      t.integer :organization_id
      t.integer :user_id
      t.timestamps
    end
    
    add_index :invoices, :organization_id
    add_index :invoices, :user_id
  end
end
