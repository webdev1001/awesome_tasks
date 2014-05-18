class FrontpageController < ApplicationController
  def index
    @tasks = Task.all
      .includes(:project, :user)
      .joins("LEFT JOIN task_assigned_users ON task_assigned_users.task_id = tasks.id")
      .where("tasks.user_id = ? || task_assigned_users.user_id = ?", current_user.id, current_user.id)
      .group("tasks.id")
      .where("tasks.state IN (?)", ["new", "open", "waiting"])
    
    sort_tasks
    
    @headlines = [{
      "sort" => "name",
      "sortval" => "name",
      "title" => _("Task")
    },{
      "sort" => "project",
      "sortval" => {:table => :Project, :col => :name},
      "title" => _("Project")
    },{
      "sort" => "priority",
      "sortval" => "priority",
      "title" => _("Priority")
    },{
      "sort" => "author",
      "sortval" => {:table => :User, :col => :name},
      "title" => _("Author")
    },{
      "sort" => "date",
      "sortval" => "date_added",
      "title" => _("Date")
    },{
      "sort" => "status",
      "sortval" => "status",
      "title" => _("Status")
    }]
    
    if can?(:admin, :admin)
      @headlines += [{
        "title" => "#{_("Hours")} / #{_("Driving")}"
      },{
        "title" => _("Transport length")
      }]
    end
  end
  
private
  
  def sort_tasks
    if params["sort"] == "project" or params["sort"].to_s.length <= 0
      @tasks = @tasks.order("projects.name, tasks.name")
    elsif params["sort"] == "name"
      @tasks = @tasks.order("tasks.name")
    elsif params["sort"] == "date"
      @tasks = @tasks.order("tasks.created_at")
    elsif params["sort"] == "author"
      @tasks = @tasks.joins(:user).order("users.name")
    elsif params["sort"] == "status"
      @tasks = @tasks.order("tasks.state")
    elsif params["sort"] == "priority"
      @tasks = @tasks.order("tasks.priority")
    else
      raise "Dont know how to sort the tasks."
    end
    
    @tasks = @tasks.reverse_order if params["sortmode"] == "desc"
  end
end
