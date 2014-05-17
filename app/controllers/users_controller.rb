class UsersController < ApplicationController
  load_and_authorize_resource
  
  def search
    render :index, :layout => false
  end
  
  def roles
    render :partial => "roles", :layout => false
  end
  
  def new
    @user = User.new
  end
  
  def create
  end
  
  def update
    if @user.update_attributes(user_params)
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(". ")
      render :edit
    end
  end
  
private
  
  def user_params
    params.require(:user).permit(:username, :password, :name, :email,
      :active)
  end
end
