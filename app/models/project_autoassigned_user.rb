class ProjectAutoassignedUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates_presence_of :user, :project
  validates_uniqueness_of :user_id, :scope => :project_id
end
