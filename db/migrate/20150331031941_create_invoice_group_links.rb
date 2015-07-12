class CreateInvoiceGroupLinks < ActiveRecord::Migration
  def change
    create_table :invoice_group_links do |t|
      t.belongs_to :invoice
      t.belongs_to :invoice_group
      t.timestamps
    end

    add_index :invoice_group_links, :invoice_id
    add_index :invoice_group_links, :invoice_group_id
  end
end
