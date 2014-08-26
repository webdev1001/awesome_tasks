class CommentsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_resource

  def new
    render :new, layout: false
  end

  def create
    @resource.assign_attributes(task_params) if @resource.is_a? Task

    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.comment = comment_with_changed_state

    respond_to do |format|
      if @comment.save && @resource.save
        @resource.delay.send_notify_new_comment(@comment, task_url(@resource)) if @resource.is_a?(Task)

        format.html { render nothing: true }
        format.json { render json: {success: true} }
      else
        format.html { render text: errors.join(". ") }
        format.json { render json: {success: false, errors: errors.join(". ")} }
      end
    end
  end

  def edit
    render :edit, layout: false
  end

  def update
    if @comment.update_attributes(comment_params)
      render nothing: true
    else
      render text: errors.join(". ")
    end
  end

  def destroy
    @comment.destroy!
    render nothing: true
  end

private

  def set_resource
    if params[:comment] && params[:comment][:resource_type] && params[:comment][:resource_id]
      @resource = ::Kernel.const_get(params[:comment][:resource_type]).find(params[:comment][:resource_id])
    elsif @comment
      @resource = @comment.resource
    end

    authorize! :show, @resource if @resource
  end

  def comment_params
    params.require(:comment).permit(:resource_type, :resource_id, :comment)
  end

  def task_params
    params.require(:task).permit(:state)
  end

  def errors
    errors = []
    errors += @comment.errors.full_messages if @comment
    errors += @resource.errors.full_messages if @resource
    return errors
  end

  def comment_with_changed_state
    comment_str = comment_params[:comment].to_s

    if @resource.state_changed?
      comment_str << "<div style=\"padding-top: 15px; padding-bottom: 15px;\">#{sprintf(_("Changed the task-status to '%s'."), @resource.translated_state)}</div>"
    end

    comment_str
  end
end
