class TasksController < ApplicationController
  load_and_authorize_resource
  before_filter :set_task_resources

  def index
    if can? :manage, User
      @users = User.all.order(:name)
    else
      @users = current_user.users_list
    end

    @projects = current_user.visible_projects.order(:name)

    @ransack_params = params[:q] || {}
    @ransack = Task.ransack(@ransack_params)
    @tasks = @ransack.result.includes(:user, :project).order(:name)
    @tasks = @tasks.paginate(page: params[:page], per_page: 40)
  end

  def new
    @task.priority = 1 unless @task.priority
    @task.state = "open" unless @task.state
  end

  def create
    @task.user = current_user
    @task.description = UserReferences.new(text: @task.description).parse_user_references

    if @task.save
      # Mail auto-assigned users
      @task.task_assigned_users.each do |task_assigned_user|
        TaskAssignedUserMailer.notification(task_assigned_user.id, task_url(@task)).deliver_later!
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
    @task.assign_attributes(task_params)
    @task.description = UserReferences.new(text: @task.description).parse_user_references

    respond_to do |format|
      if @task.save
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
    assigned_user.send_notify(task_url(@task))

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

  helper_method :projects_collection
  def projects_collection
    projects = current_user.visible_projects.where(projects: {state: "active"}).order(:name).to_a
    projects << @task.project if !@task.new_record? && !projects.include?(@task.project)

    return projects
  end
end
