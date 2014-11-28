class TagsController < ApplicationController
  def create
    resource = resource_from_params(params[:tag][:resource_type], params[:tag][:resource_id])
    resource.tag_list.add(params[:tag][:name])

    unless resource.save
      flash[:error] = resource.errors.full_messages.join(". ")
    end

    redirect_to resource
  end

  def destroy
    resource = resource_from_params(params[:resource_type], params[:resource_id])
    resource.tag_list.remove(params[:id])

    unless resource.save
      flash[:error] = resource.errors.full_messages.join(". ")
    end

    redirect_to resource
  end

private

  def resource_from_params type, id
    resource = type.constantize.find(id)
    authorize! :show, resource
    return resource
  end
end
