class CreateAccountLines < ActiveRecord::Migration
  def change
    create_table :account_lines do |t|
      t.belongs_to :account
      t.belongs_to :account_import
      t.belongs_to :invoice
      t.string :text
      t.datetime :interest_at
      t.datetime :booked_at
      t.float :amount
      t.timestamps
    end

    add_index :account_lines, :account_id
    add_index :account_lines, :account_import_id
    add_index :account_lines, :invoice_id
    add_index :account_lines, :interest_at
    add_index :account_lines, :booked_at
    add_index :account_lines, :amount
  end
end
