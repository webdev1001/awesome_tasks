class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :id_per_resource
      t.string :resource_type
      t.integer :resource_id
      t.integer :user_id
      t.text :comment
      t.timestamps
    end
    
    add_index :comments, [:resource_type, :resource_id]
    add_index :comments, :user_id
  end
end
