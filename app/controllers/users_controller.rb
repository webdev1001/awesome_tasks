class UsersController < ApplicationController
  before_filter :set_user
  
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
  
  def log_in_as
    sign_in @user
    redirect_to user_path(@user)
  end
  
private
  
  def set_user
    if params[:id]
      @user = User.find(params[:id])
      authorize! action_name.to_sym, @user
    end
  end
  
  def user_params
    params.require(:user).permit(:username, :password, :name, :email,
      :active)
  end
end
