class AddUserCheckedIdToTaskChecks < ActiveRecord::Migration
  def change
    add_column :task_checks, :user_checked_id, :integer
    add_index :task_checks, :user_checked_id
  end
end
