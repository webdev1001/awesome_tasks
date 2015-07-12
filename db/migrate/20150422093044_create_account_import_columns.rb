class CreateAccountImportColumns < ActiveRecord::Migration
  def change
    create_table :account_import_columns do |t|
      t.belongs_to :account_import
      t.integer :column_no
      t.string :column_type
      t.timestamps
    end

    add_index :account_import_columns, :account_import_id
  end
end
