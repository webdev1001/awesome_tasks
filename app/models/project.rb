class Project < ActiveRecord::Base
  belongs_to :user_added, :class_name => "User"
  belongs_to :organization

  has_many :tasks, dependent: :restrict_with_error
  has_many :user_project_links, dependent: :destroy
  has_many :users, through: :user_project_links
  has_many :project_autoassigned_users, dependent: :destroy
  has_many :autoassigned_users, through: :project_autoassigned_users, source: :user

  validates_presence_of :organization
end
