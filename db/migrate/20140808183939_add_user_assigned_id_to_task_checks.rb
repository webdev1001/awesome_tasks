class AddUserAssignedIdToTaskChecks < ActiveRecord::Migration
  def change
    add_column :task_checks, :user_assigned_id, :integer
    add_index :task_checks, :user_assigned_id
  end
end
