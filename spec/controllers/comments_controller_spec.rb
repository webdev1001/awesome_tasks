require "spec_helper"

describe CommentsController do
  let!(:user){ create :user, locale: "da" }
  let!(:task){ create :task, user: user }
  let(:comment){ create :comment, resource: task, user: user }

  render_views

  context "#create" do
    let!(:admin){ create :user_admin }
    let!(:assigned_user){ create :user, locale: "en" }
    let!(:other_user){ create :user }

    before do
      task.assigned_users << assigned_user
    end

    it "#notify_emails" do
      result = task.notify_emails
      result.length.should eq 2

      result[0].should eq(email: user.email, user: user)
      result[1].should eq(email: assigned_user.email, user: assigned_user)
    end

    it "works and sends mail to both owner and assigned users" do
      sign_in admin
      task.assigned_users.count.should eq 1
      ActionMailer::Base.deliveries.clear

      expect {
        post :create, comment: {resource_type: "Task", resource_id: task.id, comment: "Test comment"}, task: {state: task.state}
        assigns(:comment).errors.to_a.should eq []
      }.to change { ActionMailer::Base.deliveries.count }.by(2)

      mail = ActionMailer::Base.deliveries.select{ |mail| mail.to.include?(user.email) }.first
      mail.subject.should include "Ny kommentar fra: #{admin.name}"
      mail.body.to_s.should include "<a href=\"#{task_url(task)}\">"
      mail.body.to_s.should include "Kommentar"
      mail.body.to_s.should include "Hej #{user.name}"
      mail.in_reply_to.should eq task.first_email_id

      from_email = Rails.application.config.action_mailer.default_options[:from]
      mail.header["From"].to_s.should eq "#{admin.name} <#{from_email}>"
    end

    it "changes the resource state" do
      sign_in admin
      post :create, task: {state: "closed"}, comment: {resource_type: "Task", resource_id: task.id, comment: "Test comment"}

      expect(response).to redirect_to task_url(task)
      task.reload
      expect(task.state).to eq "closed"
    end
  end

  it "#new" do
    sign_in task.user
    get :new, comment: {resource_type: "Task", resource_id: task.id}
    expect(response).to be_success
  end

  it "#edit" do
    sign_in task.user
    get :edit, id: comment.id
    expect(response).to be_success
  end
end
