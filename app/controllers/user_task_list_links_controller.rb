class UserTaskListLinksController < ApplicationController
  before_filter :set_user_task_list_link

  def create
    @user_task_list_link = UserTaskListLink.new(user_task_list_link_params)
    @user_task_list_link.user = current_user

    if @user_task_list_link.save
      render nothing: true
    else
      render text: @user_task_list_link.errors.full_messages.join(". ")
    end
  end

  def destroy
    @user_task_list_link.destroy!
    render nothing: true
  end

private

  def set_user_task_list_link
    if params[:id]
      @user_task_list_link = UserTaskListLink.find(params[:id])
      authorize! action_name.to_sym, @user_task_list_link
    end
  end

  def user_task_list_link_params
    params.require(:user_task_list_link).permit(:task_id)
  end
end
