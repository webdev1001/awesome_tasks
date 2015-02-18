class AddUserAssignerToTaskChecks < ActiveRecord::Migration
  def change
    add_column :task_checks, :user_assigner_id, :integer
    add_index :task_checks, :user_assigner_id
  end
end
