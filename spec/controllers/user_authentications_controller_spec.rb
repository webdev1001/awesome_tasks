require "spec_helper"

describe UserAuthenticationsController do
  context "doesnt log inactive users in" do
    let!(:inactive_user){ create :user, :username => "Test Name", :encrypted_password => Digest::MD5.hexdigest("123"), :active => false }
    
    it "doesnt let him log in" do
      request.env["HTTP_REFERER"] = root_url
      post :create, :texuser => "Test Name", :texpass_md5 => Digest::MD5.hexdigest("123")
      controller.flash[:warning].should eq "That user is not active any more and cant be used."
    end
  end
  
  context "lets users log in" do
    let!(:user){ create :user, :username => "Test Name", :encrypted_password => Digest::MD5.hexdigest("123") }
    
    it "lets them log in" do
      request.env["HTTP_REFERER"] = root_url
      post :create, :texuser => "Test Name", :texpass_md5 => Digest::MD5.hexdigest("123")
      controller.flash[:warning].should eq nil
      controller.current_user.id.should eq user.id
    end
  end
end
