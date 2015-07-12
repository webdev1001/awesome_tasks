class AddTimelogIdToInvoiceLines < ActiveRecord::Migration
  def change
    add_column :invoice_lines, :timelog_id, :integer
    add_index :invoice_lines, :timelog_id
  end
end
