class CreateAccountLines < ActiveRecord::Migration
  def change
    create_table :account_lines do |t|
      t.belongs_to :account
      t.belongs_to :invoice
      t.string :text
      t.datetime :rent_at
      t.datetime :booked_at
      t.float :amount
      t.timestamps
    end

    add_index :account_lines, :account_id
    add_index :account_lines, :invoice_id
  end
end
