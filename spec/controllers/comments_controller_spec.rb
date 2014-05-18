require "spec_helper"

describe CommentsController do
  context "#create" do
    let(:admin){ create :user_admin }
    let(:task){ create :task, :user => admin }
    let(:user){ create :user }
    
    it "works and sends mail" do
      sign_in admin
      
      expect {
        post :create, :comment => {:resource_type => "Task", :resource_id => task.id, :comment => "Test comment"}, :task => {:state => task.state}
        assigns(:comment).errors.to_a.should eq []
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
      mail_body = ActionMailer::Base.deliveries.last.body
      mail_body.should include "<a href=\"#{task_url(task)}\">"
      
      # puts ActionMailer::Base.deliveries.last.body
    end
  end
end
