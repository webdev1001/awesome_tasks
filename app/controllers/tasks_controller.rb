class TasksController < ApplicationController
  load_and_authorize_resource
  before_filter :set_task_resources

  def index
    if can? :manage, User
      @users = User.all.order(:name)
    else
      @users = current_user.users_list
    end

    @ransack_params = params[:q] || {}
    @ransack = Task.ransack(@ransack_params)
    @tasks = @ransack.result.includes(:user, :project).order(:name)
  end

  def new
    if params[:task]
      @task = Task.new(params[:task].permit!)
    else
      @task = Task.new
    end

    @task.priority = 1 unless @task.priority
    @task.state = "open" unless @task.state
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user if signed_in?

    if @task.save
      # Mail auto-assigned users
      @task.task_assigned_users.each do |task_assigned_user|
        TaskAssignedUserMailer.delay.notification(task_assigned_user, task_url(@task))
      end

      redirect_to task_path(@task)
    else
      flash[:error] = @task.errors.full_messages.join(". ")
      render :new
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @task.update_attributes(task_params)
        format.html { redirect_to task_path(@task) }
        format.json { render json: {success: true} }
      else
        format.html {
          flash[:error] = @task.errors.full_messages.join(". ")
          render :edit
        }

        format.json { render json: {success: false, errors: @task.errors.full_messages.join(". ")} }
      end
    end
  end

  def checks
    render partial: "checks", layout: false, locals: {checks: @checks, task: @task}
  end

  def users
    render partial: "users", layout: false, locals: {users: @users, task: @task}
  end

  def comments
    render partial: "comments", layout: false, locals: {comments: @comments, task: @task}
  end

  def timelogs
    render partial: "timelogs", layout: false, locals: {timelogs: @timelogs, task: @task}
  end

  def show
    @comments = @task.comments
  end

  def assign_user
    assigned_user = @task.task_assigned_users.find_or_initialize_by(
      user_id: params[:user_id],
      user_assigned_by_id: current_user.id
    )

    assigned_user.save!
    assigned_user.delay.send_notify(task_url(@task))

    render json: {success: true}
  end

  def destroy
    destroy_model @task
  end

private

  def set_task_resources
    if params[:id]
      @checks = @task.task_checks.order(:name)
      @users = @task.task_assigned_users
      @comments = @task.comments.order(:created_at)
      @timelogs = @task.timelogs.order(:id).reverse_order
    end
  end

  def task_params
    params.require(:task).permit(:name, :project_id, :task_type, :state, :priority, :description)
  end
end
