class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @ransack_params = params[:q] || {}
    @ransack = Project.ransack(@ransack_params)
    @projects = @ransack.result.order(:name)
  end

  def new
    if params[:project]
      @project = Project.new(project_params)
    else
      @project = Project.new
    end

    @project.user_added = current_user
  end

  def create
    @project = Project.new(project_params)
    @project.user_added = current_user

    if @project.save
      redirect_to project_path(@project)
    else
      flash[:error] = @project.errors.full_messages.join(". ")
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to project_path(@project)
    else
      flash[:error] = @project.errors.full_messages.join(". ")
      render :edit
    end
  end

  def show
    @tasks = @project.tasks.order("tasks.created_at DESC, tasks.name")
  end

  def destroy
    @project.destroy!
    redirect_to projects_path
  end

  def assigned_users
    render partial: "assigned_users", layout: false, locals: {project: @project}
  end

  def assign_user
    @project.user_project_links.create(user_id: params[:user_id])
    render nothing: true
  end

private

  def project_params
    params.require(:project).permit(:name, :description, :organization_id, :deadline_at, :price_per_hour, :price_per_hour_transport)
  end
end
