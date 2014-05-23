class CreateUserProjectLinks < ActiveRecord::Migration
  def change
    create_table :user_project_links do |t|
      t.integer :user_id
      t.integer :project_id
      t.timestamps
    end
    
    add_index :user_project_links, :user_id
    add_index :user_project_links, :project_id
  end
end
