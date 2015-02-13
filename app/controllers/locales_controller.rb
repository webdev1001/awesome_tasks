class LocalesController < ApplicationController
  def new
  end

  def create
    locale = params[:locale][:locale]

    I18n.locale = locale
    session[:locale] = locale
    current_user.update_attributes!(locale: locale) if signed_in?

    if request.xhr?
      render nothing: true
    else
      redirect_to root_path
    end
  end
end
