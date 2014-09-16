require "spec_helper"

describe TagsController do
  let!(:user_admin){ create :user_admin }
  let!(:task){ create :task }

  before do
    sign_in user_admin
  end

  it "#create" do
    post :create, tag: {resource_type: "Task", resource_id: task.id, name: "test"}
    response.should redirect_to(task_url(task))
    task.tag_list.should eq ["test"]
  end

  it "#destroy" do
    task.tag_list.add("test")
    task.save!
    task.tag_list.should eq ["test"]

    delete :destroy, id: "test", resource_type: "Task", resource_id: task.id
    response.should redirect_to(task_url(task))
    controller.flash[:error].should eq nil

    task.reload
    task.tag_list.should eq []
  end
end
