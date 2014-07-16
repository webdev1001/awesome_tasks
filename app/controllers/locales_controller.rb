class LocalesController < ApplicationController
  def set
    I18n.locale = params[:locale]
    session[:locale] = I18n.locale

    if signed_in?
      current_user.locale = params[:locale]
      current_user.save!
    end

    render nothing: true
  end
end
