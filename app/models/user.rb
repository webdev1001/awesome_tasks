require Rails.root.join('lib', 'devise', 'encryptors', 'md5')

class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :encryptable
  
  has_many :tasks, :dependent => :restrict_with_exception
  has_many :task_assigned_users, :dependent => :destroy
  has_many :user_rank_links, :dependent => :destroy
  has_many :user_project_links, :dependent => :destroy
  has_many :projects, :through => :user_project_links, :dependent => :destroy
  has_many :user_roles, :dependent => :destroy
  has_many :user_task_list_links, :dependent => :destroy
  
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
  
  def has_rank?(rank_str)
    rank = self.ob.get_by(:User_rank, {
      "id_str" => rank_str
    })
    return false if !rank
    
    rank_link = self.ob.get_by(:User_rank_link, {
      "user" => self,
      "rank" => rank
    })
    return false if !rank_link
    
    return true
  end
  
  def has_email?
    return Knj::Strings.is_email?(self[:email])
  end
  
  def customers
    customers = {}
    self.ob.list(:Project, {
      [:User_project_link, "user_id"] => self.id
    }) do |project|
      customer = project.customer
      next if !customer or customers.key?(customer.id)
      customers[customer.id] = customer
    end
    
    customers = customers.values.to_a
    customers.sort do |cust1, cust2|
      cust1.name.downcase <=> cust2.name.downcase
    end
    
    return customers
  end
  
  #A list of all relevant users for this user (from the same customer).
  def users_list
    users = {}
    
    customers.each do |customer|
      customer.projects.each do |project|
        project.users do |user|
          users[user.id] = user
        end
      end
    end
    
    users = users.values
    users.sort do |user1, user2|
      user1.name.downcase <=> user2.name.downcase
    end
    
    return users
  end
  
  def admin?
    user_roles.where(:role => "administrator").any?
  end
  
  def users_with_access_to
    if admin?
      User.all
    else
      users_list
    end
  end
  
  def projects_with_access_to
    if user_roles.where(:role => "administrator").any?
      Project.all
    else
      projects
    end
  end
end
