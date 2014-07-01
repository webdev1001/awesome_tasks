class CreateInvoiceLines < ActiveRecord::Migration
  def change
    create_table :invoice_lines do |t|
      t.string :title
      t.float :amount
      t.integer :quantity
      t.integer :invoice_id
      t.timestamps
    end
    
    add_index :invoice_lines, :invoice_id
  end
end
