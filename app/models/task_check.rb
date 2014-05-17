class TaskCheck < ActiveRecord::Base
  belongs_to :task
  belongs_to :added_user, :class_name => "User"
end
