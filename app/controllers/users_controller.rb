class UsersController < ApplicationController
  before_filter :set_user
  
  def search
    @ransack_params = params[:q] || {}
    @ransack = User.ransack(@ransack_params)
    @users = @ransack.result.order(:name)
    render :index, :layout => false
  end
  
  def roles
    render :partial => "roles", :layout => false
  end
  
  def show
    @ransack_params = params[:q] || {}
    @ransack = @user.tasks.ransack(@ransack_params)
    
    @tasks = @ransack.result.includes(:project => :organization)
    @tasks = @tasks.order(:created_at).reverse_order unless @ransack_params[:s]
    @tasks = @tasks.paginate(:page => params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @form_data = {
      :user_id => @user.id,
      :roles_user_path => roles_user_path(@user),
      :new_user_role_path => new_user_role_path(:user_id => @user.id),
      :add_rank_text => _("Add rank"),
      :new_role_path => new_user_role_path(:user_role => {:user_id => @user.id})
    }
  end
  
  def index
    @ransack_params = params[:q] || {}
    @ransack = User.ransack(@ransack_params)
    @users = @ransack.result.order(:name)
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(". ")
      render :new
    end
  end
  
  def update
    params_save = user_params
    params_save.delete(:password)
    params_save.delete(:encrypted_password) unless params_save[:encrypted_password].present?
    
    if @user.update_attributes(params_save)
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
    else
      authorize! action_name.to_sym, User
    end
  end
  
  def user_params
    params.require(:user).permit(:username, :password, :encrypted_password, :name, :email, :active)
  end
end
