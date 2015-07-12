class TaskAssignedUsersController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def create
    @task_assigned_user.user_assigned_by = current_user

    if @task_assigned_user.save
      redirect_to task_path(@task_assigned_user.task, anchor: "mobile-tab-tab-assigned-users")
    else
      render :new
    end
  end

  def destroy
    @task_assigned_user.destroy!

    if request.xhr?
      render nothing: true
    else
      redirect_to task_path(@task_assigned_user.task, anchor: "mobile-tab-tab-assigned-users")
    end
  end

private

  def task_assigned_user_params
    params.require(:task_assigned_user).permit(:task_id, :user_id)
  end
end
