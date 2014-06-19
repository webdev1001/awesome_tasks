require "spec_helper"

describe UsersController do
  let(:admin){ create :user_admin }
  let(:user){ create :user }
  
  it "#create" do
    sign_in admin
    post :create, :user => {:email => Forgery(:internet).email_address, :password => "", :encrypted_password => Digest::MD5.hexdigest("password")}
    controller.flash[:error].should eq nil
    user = User.last
    user.should_not eq nil
    response.location.should eq user_url(user)
  end
  
  it "#update" do
    sign_in admin
    post :update, :id => user.id, :user => {:encrypted_password => Digest::MD5.hexdigest("new_password"), :password => "123"}
    controller.flash[:error].should eq nil
    response.location.should eq user_url(user)
    user.reload
    user.encrypted_password.should eq Digest::MD5.hexdigest("new_password")
  end
end
