class ApplicationController < ActionController::Base
  # To automatically set owner on PublicActivity-tracked models.
  include PublicActivity::StoreController
  include LightMobile::DynamicRenderer

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :redirect_to_sign_in_if_not_signed_in
  before_filter :redirect_old_task_urls_to_new_ones

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

  def destroy_model model
    models_path = StringCases.camel_to_snake(model.class.name).pluralize

    if model.destroy
      redirect_to __send__("#{models_path}_path")
    else
      flash[:error] = model.errors.full_messages.join(". ")
      redirect_to [:edit, model]
    end
  end

private

  # Redirects old URL's to new ones.
  def redirect_old_task_urls_to_new_ones
    if params[:show] == "tasks_show" && params[:task_id] && Task.exists?(params[:task_id])
      redirect_to task_url(params[:task_id])
    elsif params[:show] == "users_show" && params[:user_id] && User.exists?(params[:user_id])
      redirect_to user_url(params[:user_id])
    end
  end

  def redirect_to_sign_in_if_not_signed_in
    if !signed_in? && controller_name != "sessions" && controller_name != "locales" && controller_name != "passwords"
      session[:previous_url] = request.original_url
      redirect_to new_user_session_path
    end
  end

  def after_sign_in_path_for resource
    session[:previous_url] || root_path
  end
end
