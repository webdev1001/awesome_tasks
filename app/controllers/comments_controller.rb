class CommentsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_resource

  def new
    if request.xhr?
      render :new, layout: false
    end
  end

  def create
    @resource.assign_attributes(task_params) if @resource.is_a? Task

    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.comment = comment_with_changed_state_and_references

    respond_to do |format|
      if @comment.save && @resource.save
        @resource.send_notify_new_comment(@comment, task_url(@resource)) if @resource.is_a?(Task)

        format.html { redirect_to @comment.resource }
        format.json { render json: {success: true} }
      else
        format.html { render text: errors.join(". ") }
        format.json { render json: {success: false, errors: errors.join(". ")}, status: :internal_server_error }
      end
    end
  end

  def edit
    if request.xhr?
      render :edit, layout: false
    end
  end

  def update
    @comment.assign_attributes(comment_params)
    @comment.comment = comment_with_changed_state_and_references

    if @comment.save
      render nothing: true
    else
      render text: errors.join(". ")
    end
  end

  def destroy
    @comment.destroy!
    render nothing: true
  end

  def show
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

  def comment_with_changed_state_and_references
    comment_str = comment_params[:comment].to_s

    if @resource.state_changed?
      comment_str << "<div style=\"padding-top: 15px; padding-bottom: 15px;\">#{t(".changed_the_task_status", state: @resource.translated_state)}</div>"
    end

    comment_str = UserReferences.new(text: comment_str).parse_user_references
    return comment_str
  end
end
