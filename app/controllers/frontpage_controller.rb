class FrontpageController < ApplicationController
  def index
    @tasks = []
    
    current_user.task_assigned_users.each do |task_assigned_users|
      @tasks << task_assigned_users.task
    end
    
    current_user.tasks.each do |task|
      @tasks << task unless @tasks.map{ |task| task.id }.include?(task.id)
    end
  end
end
