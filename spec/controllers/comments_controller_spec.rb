require "spec_helper"

describe CommentsController do
  context "#create" do
    let(:admin){ create :user_admin }
    let(:task){ create :task, :user => user }
    let(:user){ create :user, :locale => "da" }
    
    it "works and sends mail" do
      sign_in admin
      
      expect {
        post :create, :comment => {:resource_type => "Task", :resource_id => task.id, :comment => "Test comment"}, :task => {:state => task.state}
        assigns(:comment).errors.to_a.should eq []
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
      mail_body = ActionMailer::Base.deliveries.last.body.to_s
      mail_body.should include "<a href=\"#{task_url(task)}\">"
      
      # Ensures the mail is being translated to the users language.
      mail_body.should include "Kommentar"
      mail_body.should include "Hej #{user.name}"
      
      # puts ActionMailer::Base.deliveries.last.body
    end
  end
end
