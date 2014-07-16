class CreateTaskAssignedUsers < ActiveRecord::Migration
  def change
    create_table :task_assigned_users do |t|
      t.integer :task_id
      t.integer :user_id
      t.integer :user_assigned_by_id
      t.timestamps
    end

    add_index :task_assigned_users, :task_id
    add_index :task_assigned_users, :user_id
    add_index :task_assigned_users, :user_assigned_by_id
  end
end
