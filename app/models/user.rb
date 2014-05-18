class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  
  has_many :tasks
  has_many :task_assigned_users
  has_many :user_rank_links
  has_many :user_project_links
  has_many :projects, :through => :user_project_links
  has_many :user_roles
  has_many :user_task_list_links
  
  def delete
    raise _("Cannot delete user because that user has created tasks.") if ob.get_by(:Task, {"user" => self})
  end
  
  def name
    if self[:name].to_s.length > 0
      return self[:name]
    elsif self[:username].to_s.length > 0
      return self[:username]
    end
    
    raise "Could not figure out a name?"
  end
  
  def locale
    return self[:locale] if self[:locale].to_s.length > 0
    return "en_GB"
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
  
  def has_view_access?(user)
    return false if !user
    return true if user.has_rank?("admin")
    
    res = _db.query("
      SELECT
        *
      
      FROM
        User_project_link AS user_link,
        User_project_link AS my_link
      
      WHERE
        user_link.user_id = '#{_db.esc(user.id)}' AND
        my_link.user_id = '#{_db.esc(self.id)}' AND
        user_link.project_id = my_link.project_id
      
      LIMIT
        1
    ").fetch
    return true if res
    
    return false
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
  
  def projects_with_access_to
    if user_roles.where(:role => "administrator").any?
      Project.all
    else
      projects
    end
  end
end
