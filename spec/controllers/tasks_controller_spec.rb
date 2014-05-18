require "spec_helper"

describe TasksController do
  let!(:admin){ create :user_admin }
  let!(:task){ create :task, :user => admin }
  
  context "#assign_user" do
    let(:user_to_be_assigned){ create :user }
    
    it "works" do
      sign_in admin
      
      expect {
        post(:assign_user, {
          :id => task.id,
          :user_id => user_to_be_assigned.id
        })
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
      mail_body = ActionMailer::Base.deliveries.last.body
      mail_body.should include task_url(task)
      mail_body.should include user_to_be_assigned.name
      mail_body.should include admin.name
      
      # puts ActionMailer::Base.deliveries.last.body
    end
  end
end
