class ProfileController < ApplicationController
  def index
    @ransack_params = params[:q] || {}
    @ransack = current_user.tasks.ransack(@ransack_params)
    @tasks = @ransack.result.paginate(page: params[:page], per_page: 30)
    @tasks = @tasks.order(:name) unless params[:s]
  end

  def update
    if Digest::MD5.hexdigest("") != params["passwd_md5"]
      current_user.encrypted_password = params["passwd_md5"]
    end

    current_user.assign_attributes(user_params)
    current_user.save!

    redirect_to profile_index_path
  end

private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
