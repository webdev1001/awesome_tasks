class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @ransack_params = params[:q] || {}
    @ransack = Project.ransack(@ransack_params)
    @projects = @ransack.result
    @projects = @projects.order(:name) unless params[:s]
    @projects = @projects.paginate(page: params[:p], per_page: 40)
  end

  def new
  end

  def create
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
    @ransack_values = params[:q] || {}
    @ransack = @project.tasks.ransack(@ransack_values)

    @tasks = @ransack.result
    @tasks = @tasks.order("tasks.created_at DESC, tasks.name") unless @ransack_values[:s]
    @tasks = @tasks.paginate(page: params[:page], per_page: 40)
  end

  def destroy
    destroy_model @project
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
