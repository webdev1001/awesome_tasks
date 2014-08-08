class TaskAssignedUsersController < ApplicationController
  load_and_authorize_resource

  def destroy
    @task_assigned_user.destroy!
    render nothing: true
  end
end
