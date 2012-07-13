class Knjtasks::Project < Knj::Datarow
  has_one [
    {:class => :User, :col => :added_user_id, :method => :added_user, :required => true},
    {:class => :Customer, :col => :customer_id, :method => :customer, :required => true}
  ]
  
  has_many [
    {:class => :Task, :col => :project_id, :depends => true},
    {:class => :User_project_link, :col => :project_id, :method => :users, :autodelete => true, :depends => true}
  ]
  
  def self.add(d)
    raise _("Invalid name given.") if d.data[:name].to_s.strip.length <= 0
    
    d.data[:added_user_id] = _site.user.id if !d.data[:added_user_id] and _site.user
    d.data[:added_date] = Time.new if !d.data[:added_date]
  end
  
  def html
    return "<a href=\"?show=project_show&amp;project_id=#{id}\">#{name.html}</a>"
  end
end