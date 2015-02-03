class ChangeFloatsToDecimals < ActiveRecord::Migration
  def up
    change_column :invoices, :amount, :decimal, precision: 10, scale: 2
    change_column :invoice_lines, :amount, :decimal, precision: 10, scale: 2
    change_column :projects, :price_per_hour, :decimal, precision: 10, scale: 2
    change_column :projects, :price_per_hour_transport, :decimal, precision: 10, scale: 2
  end

  def down
    change_column :invoices, :amount, :float
    change_column :invoice_lines, :amount, :float
    change_column :projects, :price_per_hour, :float
    change_column :projects, :price_per_hour_transport, :float
  end
end
