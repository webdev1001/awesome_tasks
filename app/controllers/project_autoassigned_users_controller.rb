class ProjectAutoassignedUsersController < ApplicationController
  before_filter :set_project
  before_filter :set_autoassigned_user
  
  def new
    @project_autoassigned_user = ProjectAutoassignedUser.new(:project_id => @project.id)
  end
  
  def create
    project_autoassigned_user = @project.project_autoassigned_users.new(project_autoassigned_user_params)
    
    if project_autoassigned_user.save
      redirect_to project_path(@project)
    else
      render :json => {
        :success => false,
        :error => project_autoassigned_user.errors.full_messages.join(". ")
      }
    end
  end
  
  def destroy
    project_autoassigned_user = ProjectAutoassignedUser.find(params[:id])
    project_autoassigned_user.destroy!
    render :nothing => true
  end
  
private
  
  def project_autoassigned_user_params
    params.require(:project_autoassigned_user).permit(:user_id)
  end
  
  def set_autoassigned_user
    if params[:id].to_i > 0
      @project_autoassigned_user = @project.project_autoassigned_users.find(params[:id])
      authorize! action_name.to_sym, @project_autoassigned_user
    else
      authorize! action_name.to_sym, ProjectAutoassignedUser
    end
  end
  
  def set_project
    @project = Project.find(params[:project_id])
  end
  
  helper_method :users_collection
  def users_collection
    assigned_user_ids = @project.project_autoassigned_users.map{ |aa_user| puts "AaUser: #{aa_user.inspect}"; aa_user.user_id }
    
    query = current_user
      .visible_users
      .order(:name)
    
    query = query.where("users.id NOT IN (?)", assigned_user_ids) if assigned_user_ids.any?
    
    return query
  end
end