class TaskChecksController < ApplicationController
  load_and_authorize_resource

  def new
    @task_check = @task.task_checks.new
    render :new, layout: false
  end

  def create
    @task_check = @task.task_checks.new(task_check_params)
    @task_check.user_added = current_user

    if @task_check.save
      if @task_check.user_assigned && !@task.assigned_users.include?(@task_check.user_assigned)
        @task.assigned_users << @task_check.user_assigned
      end

      render nothing: true
    else
      render text: @task_check.errors.full_messages.join(". ")
    end
  end

  def edit
    render :edit, layout: false
  end

  def update
    @task_check.assign_attributes(task_check_params)
    do_send_notifications = true if @task_check.checked_changed?

    if @task_check.save
      @task_check.delay.send_notifications(task_url(@task)) if do_send_notifications
      render nothing: true
    else
      render text: @task_check.errors.full_messages.join(". ")
    end
  end

  def destroy
    @task_check.destroy!
    render nothing: true
  end

private

  def task_check_params
    params.require(:task_check).permit(:name, :description, :checked, :user_assigned_id)
  end
end
