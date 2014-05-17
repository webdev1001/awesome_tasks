class TasksController < ApplicationController
  before_filter :set_task
  
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
  end
  
  def assign_user
    assigned_user = @task.task_assigned_users.find_or_initialize_by(:user_id => params[:id], :user_assigned_by_id => current_user.id)
    assigned_user.save!
    assigned_user.send_notify(:url => task_url(@task))
    render :json => {:success => true}
  end
  
private
  
  def set_task
    @task = Task.includes(:task_checks, :timelogs, :task_assigned_users => :user, :comments => :user).find(params[:id])
    
    if !can?(:show, @task)
      flash[:warning] = (_("You do not have access to that task and cannot view this page."))
      redirect_to :back
    end
    
    @checks = @task.task_checks.order(:name)
    @users = @task.task_assigned_users
    @comments = @task.comments.order(:created_at)
    @timelogs = @task.timelogs.order(:created_at).reverse_order
  end
end
