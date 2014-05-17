class ProfileController < ApplicationController
  def index
  end
  
  def update
    if Digest::MD5.hexdigest("") != params["passwd_md5"]
      current_user.encrypted_password = params["passwd_md5"]
    end
    
    current_user.email = params["texemail"]
    current_user.save!
    
    redirect_to profile_index_path
  end
end
