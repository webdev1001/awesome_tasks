require "spec_helper"

describe UsersController do
  let(:admin){ create :user_admin }
  let!(:user){ create :user }

  render_views

  context "#search" do
    let!(:task){ create :task }
    let!(:project){ create :project }
    let!(:user_assigned){ create :user }
    let!(:user_same_project){ create :user }
    let!(:project){ create :project }

    before do
      task.task_assigned_users.create!(user: user_assigned)
      project.users << user_assigned
      project.users << user
      project.users << user_same_project
    end

    it "shouldnt include admin but user from same project" do
      sign_in user
      get :search, ajaxsearch: true, not_in_task_id: task.id, jscallback: "task_show_assign_user_choose"
      response.should be_success
      assigns(:users).should_not include admin
      assigns(:users).should include user_same_project
      assigns(:users).should_not include user_assigned
    end

    it "shouldnt show users from a given project" do
      sign_in user
      get :search, ajaxsearch: true, not_in_project_id: project.id, jscallback: "something"
      response.should be_success
      assigns(:users).should_not include user_assigned
    end
  end

  it "#show" do
    sign_in user
    get :show, id: user.id
    response.should be_success
  end

  context "when signed in as admin" do
    before do
      sign_in admin
    end

    it "#create" do
      post :create, user: {email: Forgery(:internet).email_address, password: "", encrypted_password: Digest::MD5.hexdigest("password")}
      controller.flash[:error].should eq nil
      user = User.last
      user.should_not eq nil
      response.location.should eq user_url(user)
    end

    it "#update" do
      post :update, id: user.id, user: {encrypted_password: Digest::MD5.hexdigest("new_password"), password: "123"}
      controller.flash[:error].should eq nil
      response.location.should eq user_url(user)
      user.reload
      user.encrypted_password.should eq Digest::MD5.hexdigest("new_password")
    end

    it "#index" do
      get :index
      response.should be_success
    end

    it "#destroy" do
      delete :destroy, id: user.id
      response.should redirect_to(users_url)
    end

    it "#edit" do
      get :edit, id: user.id
      response.should be_success
    end

    it "#update" do
      patch :update, id: user.id, user: {email: "new_email@example.com"}
      response.should redirect_to(user)
      controller.flash.to_a.should eq []
      user.reload.email.should eq "new_email@example.com"
    end

    it "#roles" do
      get :roles, id: user.id
      response.should be_success
    end
  end
end
