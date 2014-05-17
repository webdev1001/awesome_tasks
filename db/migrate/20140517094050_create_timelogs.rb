class CreateTimelogs < ActiveRecord::Migration
  def change
    create_table :timelogs do |t|
      t.integer :task_id
      t.integer :user_id
      t.time :time
      t.time :time_transport
      t.integer :transport_length
      t.text :comment
      t.boolean :invoiced
      t.datetime :invoiced_at
      t.integer :invoiced_by_user_id
      t.timestamps
    end
    
    add_index :timelogs, :task_id
    add_index :timelogs, :user_id
    add_index :timelogs, :invoiced_by_user_id
  end
end
