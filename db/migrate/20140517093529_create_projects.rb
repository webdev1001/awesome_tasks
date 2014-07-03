class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :organization_id
      t.integer :user_added_id
      t.string :name
      t.text :description
      t.datetime :deadline_at
      t.float :price_per_hour
      t.float :price_per_hour_transport
      t.timestamps
    end
    
    add_index :projects, :organization_id
    add_index :projects, :user_added_id
  end
end
