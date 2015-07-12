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
      expect(response).to be_success
    end

    it 'renders new as mobile' do
      get :new, mobile: 1
      expect(response).to be_success
    end

    it "#create" do
      post :create, user_role: valid_attributes
      response.should redirect_to user_path(user, anchor: "mobile-tab-tab-roles")
    end

    it "#edit" do
      get :edit, id: user_role.id
      expect(response).to be_success
    end

    it 'renders edit as mobile' do
      get :edit, id: user_role.id, mobile: 1
      expect(response).to be_success
    end

    it "#update" do
      patch :update, id: user_role.id, user_role: valid_attributes
      response.should redirect_to user_path(user, anchor: "mobile-tab-tab-roles")
    end

    it "#destroy" do
      delete :destroy, id: user_role.id
      response.should redirect_to user_path(user, anchor: "mobile-tab-tab-roles")
    end
  end
end
