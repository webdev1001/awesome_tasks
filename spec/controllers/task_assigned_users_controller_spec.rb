require "spec_helper"

describe TaskAssignedUsersController do
  let(:task_assigned_user) { create :task_assigned_user }
  let(:task) { create :task }
  let(:user_admin) { create :user_admin }
  let(:user) { create :user }

  render_views

  before do
    sign_in user_admin
  end

  it "#create" do
    post :create, task_assigned_user: {user_id: user.id, task_id: task.id}
    response.should redirect_to task_path(task, anchor: "mobile-tab-tab-assigned-users")

    last_assigned = TaskAssignedUser.last
    last_assigned.user_assigned_by.should eq user_admin
  end

  it "#destroy" do
    delete :destroy, id: task_assigned_user.id
    response.should redirect_to task_path(task_assigned_user.task, anchor: "mobile-tab-tab-assigned-users")
  end
end
