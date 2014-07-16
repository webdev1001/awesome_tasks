class CreateUserTaskListLinks < ActiveRecord::Migration
  def change
    create_table :user_task_list_links do |t|
      t.integer :user_id
      t.integer :task_id
      t.timestamps
    end

    add_index :user_task_list_links, :user_id
    add_index :user_task_list_links, :task_id
  end
end
