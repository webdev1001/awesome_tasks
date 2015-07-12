class UserProjectLinksController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def create
    if @user_project_link.save
      redirect_to project_path(@user_project_link.project, anchor: "mobile-tab-tab-users")
    else
      render :new
    end
  end

  def destroy
    @user_project_link.destroy!

    if request.xhr?
      render nothing: true
    else
      redirect_to project_path(@user_project_link.project, anchor: "mobile-tab-tab-users")
    end
  end

private

  def user_project_link_params
    params.require(:user_project_link).permit(:project_id, :user_id)
  end
end
