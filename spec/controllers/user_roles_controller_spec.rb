require "spec_helper"

describe UserRolesController do
  let(:user_admin){ create :user_admin }
  let(:user){ create :user }
  let(:user_role){ create :user_role, user: user }
  let(:valid_attributes){ {user_id: user.id, role: "administrator"} }

  render_views

  context "when signed in as admin" do
    before do
      sign_in user_admin
    end

    it "#new" do
      get :new
      response.should be_success
    end

    it "#create" do
      post :create, user_role: valid_attributes
      response.should be_success
    end

    it "#edit" do
      get :edit, id: user_role.id
      response.should be_success
    end

    it "#update" do
      patch :update, id: user_role.id, user_role: valid_attributes
      response.should be_success
    end

    it "#destroy" do
      delete :destroy, id: user_role.id
      response.should be_success
    end
  end
end
