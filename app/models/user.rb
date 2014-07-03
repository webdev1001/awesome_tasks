require Rails.root.join('lib', 'devise', 'encryptors', 'md5')

class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :encryptable
  
  has_many :tasks, :dependent => :restrict_with_exception
  has_many :task_assigned_users, :dependent => :destroy
  has_many :user_rank_links, :dependent => :destroy
  has_many :user_project_links, :dependent => :destroy
  has_many :projects, :through => :user_project_links, :dependent => :destroy
  has_many :project_autoassigned_users, :dependent => :destroy
  has_many :user_roles, :dependent => :destroy
  has_many :user_task_list_links, :dependent => :destroy
  has_many :organizations, :through => :projects
  
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :email, :email => true
  
  def name!
    return name if name.present?
    return username if username.present?
    return email if email.present?
    return "#{User.model_name.human} #{id}"
  end
  
  def password_salt
    'no salt'
  end

  def password_salt=(new_salt)
  end
  
  def locale!
    return locale if locale.present?
    return "en"
  end
  
  #A list of all relevant users for this user (from the same organization).
  def visible_users
    project_ids = projects.map{ |project| project.id }
    
    query = User
      .joins(:user_project_links)
      .where("user_project_links.project_id IN (?)", project_ids)
      .group("users.id")
    
    user_ids = query.map{ |user| user.id }
    
    return User.where(:id => user_ids)
  end
  
  def admin?
    user_roles.where(:role => "administrator").any?
  end
  
  def organization_admin?
    user_roles.where(:role => "organization_administrator").any?
  end
  
  def users_with_access_to
    if admin?
      User.all
    else
      visible_users
    end
  end
  
  def visible_projects
    if admin?
      Project.all
    else
      projects
    end
  end
end
