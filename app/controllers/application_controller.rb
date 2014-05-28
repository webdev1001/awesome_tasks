class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :redirect_old_urls
  def redirect_old_urls
    if params[:show] == "tasks_show" && params[:id] && Task.exists?(params[:id])
      redirect_to task_path(params[:id])
    end
  end
  
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
end
