class TasksController < ApplicationController
  before_filter :set_task
  
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
      redirect_to task_path(@task)
    else
      flash[:error] = @task.errors.full_messages.join(". ")
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @task.update_attributes(task_params)
      redirect_to task_path(@task)
    else
      flash[:error] = @task.errors.full_messages.join(". ")
      render :edit
    end
  end
  
  def checks
    render :partial => "checks", :layout => false
  end
  
  def users
    render :partial => "users", :layout => false
  end
  
  def comments
    render :partial => "comments", :layout => false
  end
  
  def timelogs
    render :partial => "timelogs", :layout => false
  end
  
  def show
    @comments = @task.comments
  end
  
  def assign_user
    assigned_user = @task.task_assigned_users.find_or_initialize_by(
      :user_id => params[:user_id],
      :user_assigned_by_id => current_user.id
    )
    
    assigned_user.save!
    assigned_user.delay.send_notify(task_url(@task))
    
    render :json => {:success => true}
  end
  
  def destroy
    if @task.destroy
      redirect_to tasks_path
    else
      flash[:error] = @task.errors.full_messages.join(". ")
      redirect_to task_path(@task)
    end
  end
  
private
  
  def set_task
    if params[:id]
      @task = Task.includes(:task_checks, :timelogs, :task_assigned_users => :user, :comments => :user).find(params[:id])
      authorize! action_name.to_sym, @task
      
      @checks = @task.task_checks.order(:name)
      @users = @task.task_assigned_users
      @comments = @task.comments.order(:created_at)
      @timelogs = @task.timelogs.order(:created_at).reverse_order
    else
      authorize! action_name.to_sym, Task
    end
  end
  
  def task_params
    params.require(:task).permit(:name, :project_id, :task_type, :state, :priority, :description)
  end
end
