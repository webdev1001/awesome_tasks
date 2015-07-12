class FrontpageController < ApplicationController
  def index
    @ransack_params = params[:q] || {}

    @ransack = Task.ransack(@ransack_params)

    @tasks = @ransack.result.not_closed
    @tasks = @tasks.includes(:project, :user)
    @tasks = @tasks.accessible_by(current_ability, :show)
    @tasks = @tasks.joins(:project).order("projects.name, tasks.name") unless params[:q]
  end

private

  helper_method :each_task
  def each_task
    @tasks_count = 0
    @tasks.each do |task|
      next unless can? :show, task
      @tasks_count += 1

      yield(
        task: task,
        length: task.timelogs.sum(:transport_length).to_f,
        hours: task.timelogs.sum(:time).to_f / 3600.0,
        transport: task.timelogs.sum(:time_transport).to_f / 3600.0
      )
    end
  end

  helper_method :no_tasks?
  def no_tasks?
    @tasks_count <= 0
  end
end
