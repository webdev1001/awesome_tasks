class UserRolesController < ApplicationController
  load_and_authorize_resource

  def new
    @user_role = UserRole.new(params.key?(:user_role) ? user_role_params : {})

    if request.xhr?
      render :new, layout: false
    end
  end

  def create
    @user_role = UserRole.new(user_role_params)

    if @user_role.save
      if request.xhr?
        render nothing: true
      else
        redirect_to user_path(@user_role.user, anchor: "mobile-tab-tab-roles")
      end
    else
      if request.xhr?
        render text: @user_role.errors.full_messages.join(". ")
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if @user_role.update_attributes(user_role_params)
      if request.xhr?
        render nothing: true
      else
        redirect_to user_path(@user_role.user, anchor: "mobile-tab-tab-roles")
      end
    else
      if request.xhr?
        render text: @user_role.errors.full_messages.join(". ")
      else
        render :edit
      end
    end
  end

  def destroy
    @user_role.destroy!

    if request.xhr?
      render nothing: true
    else
      redirect_to user_path(@user_role.user, anchor: "mobile-tab-tab-roles")
    end
  end

private

  def user_role_params
    params.require(:user_role).permit(:user_id, :role)
  end
end
