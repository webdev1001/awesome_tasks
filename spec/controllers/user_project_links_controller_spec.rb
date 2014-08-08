require "spec_helper"

describe UserProjectLinksController do
  let(:user_project_link){ create :user_project_link }
  let(:user_admin){ create :user_admin }

  render_views

  context "when signed in as admin" do
    before do
      sign_in user_admin
    end

    it "#destroy" do
      delete :destroy, id: user_project_link.id
      response.should be_success
    end
  end
end
