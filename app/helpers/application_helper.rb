module ApplicationHelper
  include SimpleFormRansackHelper
  
  def knjrbfw_opts(query, args = {})
    list = {}
    list[""] = _("Choose:") if args[:choose]
    list[""] = _("All") if args[:all]
    
    query.each do |model|
      list[model.id] = model.name
    end
    
    return list
  end
  
  def time_as_string(time)
    return "00:00:00" unless time
    return time.strftime("%H:%M:%S")
  end
  
  def menu_items
    if signed_in?
      menu = [
        link_to(_("Frontpage"), root_path)
      ]
      
      menu << link_to(_("Customers"), customers_path) if can?(:index, Customer)
      menu << link_to(_("Projects"), projects_path) if can?(:index, Project)
      menu << link_to(_("Tasks"), tasks_path) if can?(:index, Task)
      menu << link_to(_("Users"), users_path) if can?(:index, User)
      menu << link_to(_("Timelogs"), timelogs_path) if can?(:manage, Timelog)
      menu << link_to(_("Work-status"), workstatus_index_path) if can?(:admin, :admin)
      menu << link_to(_("Administration"), "?show=admin") if can?(:admin, :admin)
      menu << link_to(_("Your profile"), profile_index_path)
      menu << link_to(_("Log out"), logout_user_authentications_path, :method => :delete)
    else
      menu = [
        link_to(_("Log in"), "?show=user_login")
      ]
    end
    
    return menu
  end
end
