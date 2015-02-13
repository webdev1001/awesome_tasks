require "spec_helper"

describe TaskChecksController do
  let(:task){ create :task }
  let(:task_check){ create :task_check, task: task }
  let(:user_admin){ create :user_admin }
  let(:user_assigned){ create :user }

  let(:valid_attributes){ {name: Forgery::LoremIpsum.words(4), description: Forgery::LoremIpsum.words(50), user_assigned_id: user_assigned.id} }

  context "when signed in as admin" do
    before do
      ActionMailer::Base.deliveries.clear
      sign_in user_admin
    end

    it "#new" do
      get :new, task_id: task.id
      response.should be_success
    end

    it "#create" do
      post :create, task_id: task.id, task_check: valid_attributes
      response.should redirect_to task
      task.assigned_users.should include user_assigned

      mail = ActionMailer::Base.deliveries.first
      mail.in_reply_to.should eq task.first_email_id
    end

    it "#edit" do
      get :edit, id: task_check.id, task_id: task.id
      response.should be_success
    end

    context "#update" do
      it "#update" do
        patch :update, id: task_check.id, task_id: task.id, task_check: valid_attributes
        response.should redirect_to task
      end

      it "sends email when being checked" do
        task_check.checked?.should eq false
        patch :update, id: task_check.id, task_id: task.id, task_check: {checked: 1}
        response.should redirect_to task
        task_check.reload
        task_check.checked?.should eq true
        ActionMailer::Base.deliveries.length.should eq task.notify_emails.length

        mail = ActionMailer::Base.deliveries.last
        mail.body.to_s.should include "has been completed"
        mail.subject.should include "completed"
        mail.in_reply_to.should eq task.first_email_id

        from_email = Rails.application.config.action_mailer.default_options[:from]
        mail.header["From"].to_s.should eq "#{user_admin.name} <#{from_email}>"
      end

      it "sends email when being unchecked" do
        task_check.update_column(:checked, true)
        task_check.checked?.should eq true
        patch :update, id: task_check.id, task_id: task.id, task_check: {checked: 0}
        response.should redirect_to task
        task_check.reload
        task_check.checked?.should eq false
        ActionMailer::Base.deliveries.length.should eq task.notify_emails.length

        mail = ActionMailer::Base.deliveries.last
        mail.body.to_s.should include "has been marked as not complete"
        mail.subject.should include "not completed"
        mail.in_reply_to.should eq task.first_email_id

        from_email = Rails.application.config.action_mailer.default_options[:from]
        mail.header["From"].to_s.should eq "#{user_admin.name} <#{from_email}>"
      end
    end

    it "#destroy" do
      delete :destroy, id: task_check.id, task_id: task.id
      response.should redirect_to task
    end
  end
end
