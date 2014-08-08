require "spec_helper"

describe TaskAssignedUsersController do
  let(:task_assigned_user){ create :task_assigned_user }
  let(:user_admin){ create :user_admin }

  render_views

  before do
    sign_in user_admin
  end

  it "#destroy" do
    delete :destroy, id: task_assigned_user.id
    response.should be_success
  end
end
