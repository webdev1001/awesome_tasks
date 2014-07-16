class UserRolesController < ApplicationController
  before_filter :set_user_role

  def new
    @user_role = UserRole.new(params.key?(:user_role) ? user_role_params : {})
    render :new, layout: false
  end

  def create
    @user_role = UserRole.new(user_role_params)

    if @user_role.save
      render nothing: true
    else
      render text: @user_role.errors.full_messages.join(". ")
    end
  end

  def edit
  end

  def update
    if @user_role.update_attributes(user_role_params)
      render nothing: true
    else
      render text: @user_role.errors.full_messages.join(". ")
    end
  end

  def destroy
    @user_role.destroy!
    render nothing: true
  end

private

  def set_user_role
    if params[:id]
      @user_role = UserRole.find(params[:id])
      authorize! action_name.to_sym, @user_role
    else
      authorize! action_name.to_sym, UserRole
    end
  end

  def user_role_params
    params.require(:user_role).permit(:user_id, :role)
  end
end
