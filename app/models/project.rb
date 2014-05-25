class Project < ActiveRecord::Base
  belongs_to :added_user, :class_name => "User"
  belongs_to :customer
  
  has_many :tasks
  has_many :user_project_links
  has_many :users, :through => :user_project_links
  
  validates_presence_of :customer
end
