class AddDateToTimelogs < ActiveRecord::Migration
  def change
    add_column :timelogs, :date, :date, :after => :user_id
  end
end
