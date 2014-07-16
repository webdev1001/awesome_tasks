class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :task_type
      t.string :state
      t.integer :priority
      t.timestamps
    end

    add_index :tasks, :project_id
    add_index :tasks, :user_id
  end
end
