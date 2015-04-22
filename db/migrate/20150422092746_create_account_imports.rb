class CreateAccountImports < ActiveRecord::Migration
  def change
    create_table :account_imports do |t|
      t.belongs_to :account
      t.string :state
      t.string :file_encoding
      t.string :separator
      t.string :amount_format
      t.datetime :executed_at
      t.datetime :finished_at
      t.timestamps
    end

    add_index :account_imports, :account_id
  end
end
