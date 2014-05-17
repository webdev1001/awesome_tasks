class UserAuthenticationsController < ApplicationController
  def new
  end
  
  def create
    user = User.where(:username => params[:texuser], :encrypted_password => params[:texpass_md5]).first
    
    if !user
      flash[:warning] = _("A user with that username and/or password was found.")
      redirect_to :back
    elsif !user.active?
      flash[:warning] = _("That user is not active any more and cant be used.")
      redirect_to :back
    else
      sign_in user
      #current_user.remember_me! if params["cheremember"] == "on"
      
      if params[:backurl].to_s.strip.length > 0
        redirect_to params[:backurl]
      else
        redirect_to root_path
      end
    end
  end
  
  def logout
    sign_out current_user
    redirect_to new_user_authentication_path
  end
end
