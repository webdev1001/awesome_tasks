class UserProjectLinksController < ApplicationController
  load_and_authorize_resource

  def destroy
    @user_project_link.destroy!
    render nothing: true
  end
end
