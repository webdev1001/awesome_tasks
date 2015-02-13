class TaskChecksController < ApplicationController
  load_and_authorize_resource
  before_filter :set_task

  def new
    if request.xhr?
      render :new, layout: false
    end
  end

  def create
    @task_check.user_added = current_user

    if @task_check.save
      if @task_check.user_assigned && !@task.assigned_users.include?(@task_check.user_assigned)
        @task.assigned_users << @task_check.user_assigned
      end

      if request.xhr?
        render nothing: true
      else
        redirect_to @task_check.task
      end
    else
      render text: @task_check.errors.full_messages.join(". ")
    end
  end

  def edit
    if request.xhr?
      render :edit, layout: false
    end
  end

  def update
    @task_check.assign_attributes(task_check_params)
    @task_check.user_assigner = current_user
    do_send_notifications = true if @task_check.checked_changed?

    if @task_check.save
      @task_check.delay.send_notifications(task_url(@task), current_user) if do_send_notifications

      if request.xhr?
        render nothing: true
      else
        redirect_to @task_check.task
      end
    else
      render text: @task_check.errors.full_messages.join(". ")
    end
  end

  def destroy
    @task_check.destroy!

    if request.xhr?
      render nothing: true
    else
      redirect_to @task_check.task
    end
  end

private

  def set_task
    @task = Task.find(params[:task_id])
    @task_check.task = @task if @task_check
  end

  def task_check_params
    params.require(:task_check).permit(:name, :description, :checked, :user_assigned_id)
  end
end
