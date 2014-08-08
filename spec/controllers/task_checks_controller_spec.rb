require "spec_helper"

describe TaskChecksController do
  let(:task){ create :task }
  let(:task_check){ create :task_check, task: task }
  let(:user_admin){ create :user_admin }
  let(:user_assigned){ create :user }

  let(:valid_attributes){ {name: Forgery::LoremIpsum.words(4), description: Forgery::LoremIpsum.words(50), user_assigned_id: user_assigned.id} }

  context "when signed in as admin" do
    before do
      sign_in user_admin
    end

    it "#new" do
      get :new, task_id: task.id
      response.should be_success
    end

    it "#create" do
      post :create, task_id: task.id, task_check: valid_attributes
      response.should be_success
      task.assigned_users.should include user_assigned
    end

    it "#edit" do
      get :edit, id: task_check.id, task_id: task.id
      response.should be_success
    end

    context "#update" do
      it "#update" do
        patch :update, id: task_check.id, task_id: task.id, task_check: valid_attributes
        response.should be_success
      end

      it "sends email when being checked" do
        ActionMailer::Base.deliveries.clear
        task_check.checked?.should eq false
        patch :update, id: task_check.id, task_id: task.id, task_check: {checked: 1}
        response.should be_success
        task_check.reload
        task_check.checked?.should eq true
        ActionMailer::Base.deliveries.length.should eq task.notify_emails.length
      end
    end

    it "#destroy" do
      delete :destroy, id: task_check.id, task_id: task.id
      response.should be_success
    end
  end
end
