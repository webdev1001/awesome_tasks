class ChangeInvoiceLinesQuantityToFloat < ActiveRecord::Migration
  def change
    change_column :invoice_lines, :quantity, :float
  end
end
