class Timelog < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  
  validates_presence_of :task, :user
end
