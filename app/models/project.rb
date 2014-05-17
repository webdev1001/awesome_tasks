class Project < ActiveRecord::Base
  belongs_to :added_user, :class_name => "User"
  belongs_to :customer
  
  has_many :tasks
  has_many :user_project_links
  
  def self.add(d)
    raise _("Invalid name given.") if d.data[:name].to_s.strip.length <= 0
    
    d.data[:added_user_id] = current_user.id if !d.data[:added_user_id] and current_user
    d.data[:added_date] = Time.new if !d.data[:added_date]
  end
  
  def html
    return "<a href=\"?show=project_show&amp;project_id=#{id}\">#{name.html}</a>"
  end
end
