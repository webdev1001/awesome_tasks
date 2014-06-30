class Timelog < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  
  validates_presence_of :task, :user
  
  scope :not_invoiced, ->{ where("timelogs.invoiced IS NULL OR timelogs.invoiced = 0") }
end
