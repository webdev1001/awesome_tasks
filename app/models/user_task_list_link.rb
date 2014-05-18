class UserTaskListLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  
  validates_presence_of :user, :task
end
