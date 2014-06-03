class UserProjectLinksController < ApplicationController
  before_filter :set_user_project_link
  
  def destroy
    @user_project_link.destroy!
    render :nothing => true
  end
  
private
  
  def set_user_project_link
    @user_project_link = UserProjectLink.find(params[:id]) if params[:id]
  end
end
