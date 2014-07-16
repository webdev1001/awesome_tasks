class CreateTaskChecks < ActiveRecord::Migration
  def change
    create_table :task_checks do |t|
      t.integer :task_id
      t.integer :user_added_id
      t.string :name
      t.text :description
      t.boolean :checked
      t.timestamps
    end

    add_index :task_checks, :task_id
    add_index :task_checks, :user_added_id
  end
end
