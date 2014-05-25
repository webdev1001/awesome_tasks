require "spec_helper"

describe CommentsController do
  context "#create" do
    let!(:admin){ create :user_admin }
    let!(:task){ create :task, :user => user }
    let!(:user){ create :user, :locale => "da" }
    let!(:assigned_user){ create :user, :locale => "en" }
    
    before do
      task.assigned_users << assigned_user
    end
    
    it "works and sends mail to both owner and assigned users" do
      sign_in admin
      task.assigned_users.count.should eq 1
      
      expect {
        post :create, :comment => {:resource_type => "Task", :resource_id => task.id, :comment => "Test comment"}, :task => {:state => task.state}
        assigns(:comment).errors.to_a.should eq []
      }.to change { ActionMailer::Base.deliveries.count }.by(2)
      
      mail_body = ActionMailer::Base.deliveries.last.body.to_s
      mail_body.should include "<a href=\"#{task_url(task)}\">"
      
      # Ensures the mail is being translated to the users language.
      mail_body.should include "Kommentar"
      mail_body.should include "Hej #{user.name}"
      
      # puts ActionMailer::Base.deliveries.last.body
    end
  end
end
