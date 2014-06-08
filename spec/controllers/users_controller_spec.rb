require "spec_helper"

describe UsersController do
  let(:admin){ create :user_admin }
  
  it "#create" do
    sign_in admin
    post :create, :user => {:email => Forgery(:internet).email_address, :password => "", :encrypted_password => Digest::MD5.hexdigest("password")}
    controller.flash[:error].should eq nil
    user = User.last
    user.should_not eq nil
    response.location.should eq user_url(user)
  end
end
