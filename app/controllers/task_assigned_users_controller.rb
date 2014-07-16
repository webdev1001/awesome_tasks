class TaskAssignedUsersController < ApplicationController
  before_filter :set_task_assigned_user

  def destroy
    @task_assigned_user.destroy!
    render nothing: true
  end

private

  def set_task_assigned_user
    @task_assigned_user = TaskAssignedUser.find(params[:id]) if params[:id]
  end
end
