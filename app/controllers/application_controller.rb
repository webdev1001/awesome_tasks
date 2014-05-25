class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :check_url
  def check_url
    if !signed_in? && controller_name != "user_authentications"
      redirect_to new_user_authentication_path(:backurl => request.original_url)
    end
  end
  
  before_filter :set_knjjsfw_url
  def set_knjjsfw_url
    @knjjsfw_url = "https://www.kaspernj.org/js"
  end
  
  before_filter :set_locale
  def set_locale
    if signed_in? && current_user.locale.present?
      I18n.locale = current_user.locale
    elsif session[:locale].present?
      I18n.locale = session[:locale]
    end
  end
  
  helper_method :available_locales
  def available_locales
    {
      "da" => _("Danish"),
      "en" => _("English")
    }
  end
  
  helper_method :head_title
  def head_title
    head_title = ""
    head_titles = {
      "customer_search" => Customer.model_name.human(:count => 2),
      "project_search" => Project.model_name.human(:count => 2),
      "task_search" => Task.model_name.human(:count => 2),
      "user_search" => User.model_name.human(:count => 2),
      "timelog_search" => Timelog.model_name.human(:count => 2),
      "workstatus" => _("Work-status"),
      "admin" => _("Administration")
    }
    
    if head_titles.has_key?(params["show"])
      head_title = head_titles[params["show"]]
    elsif params["show"] == "task_show" or (params["show"] == "task_edit" and params["task_id"])
      begin
        task = _ob.get(:Task, params["task_id"])
        head_title = task.name
      rescue Errno::ENOENT
        flash[:warning] = (_("That task could not be found."))
        redirect_to :back
      end
    elsif params["show"] == "project_show" or (params["show"] == "project_edit" and params["project_id"])
      begin
        project = _ob.get(:Project, params["project_id"])
        head_title = project.name
      rescue Errno::ENOENT
        flash[:warning] = (_("That project could not be found."))
        redirect_to :back
      end
    end
    
    if head_title.length == 0
      head_title = "knjTasks"
    else
      head_title = "#{head_title} - knjTasks"
    end
  end
end
