class UserProjectLink < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates_uniqueness_of :user, :scope => :project
end
