class TaskChecksController < ApplicationController
  before_filter :set_task_check
  
  def new
    @task_check = @task.task_checks.new
    render :new, :layout => false
  end
  
  def create
    @task_check = @task.task_checks.new(task_check_params)
    
    if @task_check.save
      render :nothing => true
    else
      render :text => @task_check.errors.full_messages.join(". ")
    end
  end
  
  def edit
    render :edit, :layout => false
  end
  
  def update
    if @task_check.update_attributes(task_check_params)
      render :nothing => true
    else
      render :text => @task_check.errors.full_messages.join(". ")
    end
  end
  
private
  
  def task_check_params
    params.require(:task_check).permit(:name, :description, :checked)
  end
  
  def set_task_check
    @task = Task.find(params[:task_id])
    
    if params[:id].to_i > 0
      @task_check = @task.task_checks.find(params[:id])
      authorize! action_name.to_sym, @task_check
    else
      authorize! action_name.to_sym, TaskCheck
    end
  end
end
