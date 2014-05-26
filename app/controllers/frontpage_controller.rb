class FrontpageController < ApplicationController
  def index
    @ransack_params = params[:q] || {}
    
    @ransack = Task
      .related_for_user(current_user)
      .not_closed
      .ransack(@ransack_params)
    
    @tasks = @ransack.result.includes(:project, :user)
    @tasks = @tasks.order("projects.name, tasks.name") unless params[:q]
  end
  
private
  
  helper_method :each_task
  def each_task
    @tasks_count = 0
    @tasks.each do |task|
      next unless can? :show, task
      @tasks_count += 1
      
      yield(
        :task => task,
        :total_length => task.timelogs.sum(:transport_length),
        :total_hors => task.timelogs.sum(:time).to_f / 3600.0,
        :total_transport => task.timelogs.sum(:time_transport).to_f / 3600.0
      )
    end
  end
  
  helper_method :no_tasks?
  def no_tasks?
    @tasks_count <= 0
  end
end
