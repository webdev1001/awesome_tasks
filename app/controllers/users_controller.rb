class UsersController < ApplicationController
  load_and_authorize_resource

  def search
    @ransack_params = params[:q] || {}
    @ransack = User.ransack(@ransack_params)

    @users = @ransack.result.order(:name)
    @users = @users.where("users.id IN (?)", current_user.users_with_access_to.map(&:id))

    not_in_task_query
    not_in_project_query

    render :index, layout: false
  end

  def roles
    render partial: "roles", layout: false
  end

  def show
    @ransack_params = params[:q] || {}
    @ransack = @user.tasks.ransack(@ransack_params)

    @tasks = @ransack.result.includes(project: :organization)
    @tasks = @tasks.order(:created_at).reverse_order unless @ransack_params[:s]
    @tasks = @tasks.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
    @form_data = {
      user_id: @user.id,
      roles_user_path: roles_user_path(@user),
      new_user_role_path: new_user_role_path(user_id: @user.id),
      add_rank_text: _("Add rank"),
      new_role_path: new_user_role_path(user_role: {user_id: @user.id})
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

  def destroy
    destroy_model @user
  end

  def log_in_as
    sign_in @user
    redirect_to user_path(@user)
  end

private

  def user_params
    params.require(:user).permit(:username, :password, :encrypted_password, :name, :email, :active)
  end

  def not_in_task_query
    return unless params[:not_in_task_id]
    task = Task.find(params[:not_in_task_id])
    @users = @users.where("users.id NOT IN (?)", task.assigned_users.map{ |user| user.id }) if task.assigned_users.any?
  end

  def not_in_project_query
    return unless params[:not_in_project_id]
    project = Project.find(params[:not_in_project_id])
    @users = @users.where("users.id NOT IN (?)", project.users.map{ |user| user.id }) if project.users.any?
  end
end
