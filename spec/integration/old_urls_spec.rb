require "spec_helper"

describe "old urls" do
  include Warden::Test::Helpers

  let(:user) { create :user }
  let(:task) { create :task, user: user }

  before do
    login_as user
  end

  it "tasks_show" do
    get root_path, show: "tasks_show", task_id: task.id
    response.should redirect_to task_url(task)
  end

  it "users_show" do
    get root_path, show: "users_show", user_id: user.id
    response.should redirect_to user_url(user)
  end
end
