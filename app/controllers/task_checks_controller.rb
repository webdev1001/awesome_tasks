class TaskChecksController < ApplicationController
  load_and_authorize_resource
  before_filter :set_task

  def new
    if request.xhr?
      render :new, layout: false
    end
  end

  def create
    set_user_checked_if_checked
    set_user_assigner_if_assigned

    @task_check.user_added = current_user

    if @task_check.save
      if @task_check.user_assigned && !@task.assigned_users.include?(@task_check.user_assigned)
        @task.assigned_users << @task_check.user_assigned
      end

      if request.xhr?
        render nothing: true
      else
        redirect_to task_path(@task_check.task, anchor: "mobile-tab-tab-checks")
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

    set_user_checked_if_checked
    set_user_assigner_if_assigned

    if @task_check.save
      if request.xhr?
        render nothing: true
      else
        redirect_to task_path(@task_check.task, anchor: "mobile-tab-tab-checks")
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
      redirect_to task_path(@task_check.task, anchor: "mobile-tab-tab-checks")
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

  def set_user_checked_if_checked
    if @task_check.checked_changed? && @task_check.checked?
      @task_check.user_checked = current_user
    end
  end

  def set_user_assigner_if_assigned
    if @task_check.user_assigned_id_changed? && @task_check.user_assigned
      @task_check.user_assigner = current_user
    end
  end
end
