class CreateProjectAutoassignedUsers < ActiveRecord::Migration
  def change
    create_table :project_autoassigned_users do |t|
      t.integer :project_id
      t.integer :user_id
      t.timestamps
    end
    
    add_index :project_autoassigned_users, :project_id
    add_index :project_autoassigned_users, :user_id
  end
end
