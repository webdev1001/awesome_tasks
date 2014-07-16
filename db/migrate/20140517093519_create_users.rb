class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password
      t.string :email
      t.string :locale
      t.boolean :active
      t.timestamps
    end

    add_index :users, :username
    add_index :users, :email
  end
end
