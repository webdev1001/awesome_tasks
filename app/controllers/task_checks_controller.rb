class TaskChecksController < ApplicationController
  load_and_authorize_resource

  def new
    @task_check = @task.task_checks.new
    render :new, layout: false
  end

  def create
    @task_check = @task.task_checks.new(task_check_params)

    if @task_check.save
      render nothing: true
    else
      render text: @task_check.errors.full_messages.join(". ")
    end
  end

  def edit
    render :edit, layout: false
  end

  def update
    if @task_check.update_attributes(task_check_params)
      render nothing: true
    else
      render text: @task_check.errors.full_messages.join(". ")
    end
  end

  def destroy
    @task_check.destroy!
    render nothing: true
  end

private

  def task_check_params
    params.require(:task_check).permit(:name, :description, :checked)
  end
end
