class UploadedFilesController < ApplicationController
  before_filter :set_and_authorize_uploaded_file
  
  def new
  end
  
  def edit
  end
  
  def show
  end
  
  def destroy
    resource = @uploaded_file.resource
    @uploaded_file.destroy!
    redirect_to resource
  end
  
private
  
  def set_and_authorize_uploaded_file
    if params[:id].to_i > 0
      @uploaded_file = UploadedFile.find(params[:id])
      authorize! action_name.to_sym, @uploaded_file
    else
      authorize! action_name.to_sym, UploadedFile
    end
  end
end
