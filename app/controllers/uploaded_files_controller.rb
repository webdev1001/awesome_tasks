class UploadedFilesController < ApplicationController
  before_filter :set_and_authorize_uploaded_file
  
  def new
    if params[:uploaded_file]
      @uploaded_file = UploadedFile.new(uploaded_file_params)
    else
      @uploaded_file = UploadedFile.new
    end
  end
  
  def create
    @uploaded_file = UploadedFile.new(uploaded_file_params)
    @uploaded_file.user = current_user
    
    if @uploaded_file.save
      redirect_to @uploaded_file.resource
    else
      flash[:error] = @uploaded_file.errors.full_messages.join(". ")
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @uploaded_file.update_attributes(uploaded_file_params)
      redirect_to @uploaded_file.resource
    else
      flash[:error] = @uploaded_file.errors.full_messages.join(". ")
      render :edit
    end
  end
  
  def show
  end
  
  def destroy
    resource = @uploaded_file.resource
    @uploaded_file.destroy!
    redirect_to resource
  end
  
  def index
    @values = params[:q] || {}
    @q = UploadedFile.ransack(@values)
    @uploaded_files = @q.result
  end
  
private
  
  def uploaded_file_params
    params.require(:uploaded_file).permit(:resource_type, :resource_id, :title, :file)
  end
  
  def set_and_authorize_uploaded_file
    if params[:id].to_i > 0
      @uploaded_file = UploadedFile.find(params[:id])
      authorize! action_name.to_sym, @uploaded_file
    else
      authorize! action_name.to_sym, UploadedFile
    end
  end
end
