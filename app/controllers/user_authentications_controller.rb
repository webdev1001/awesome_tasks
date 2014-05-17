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
        redirect_to frontpage_index_path
      end
    end
  end
  
  def destroy
    sign_out
    redirect_to("?show=user_login")
  end
end
