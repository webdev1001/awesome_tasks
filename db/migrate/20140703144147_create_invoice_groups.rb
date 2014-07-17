class CreateInvoiceGroups < ActiveRecord::Migration
  def change
    create_table :invoice_groups do |t|
      t.string :name
    end
  end
end
