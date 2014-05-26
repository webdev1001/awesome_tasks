require "spec_helper"

describe CommentsController do
  context "#create" do
    let!(:admin){ create :user_admin }
    let!(:task){ create :task, :user => user }
    let!(:user){ create :user, :locale => "da" }
    let!(:assigned_user){ create :user, :locale => "en" }
    let!(:other_user){ create :user }
    
    before do
      task.assigned_users << assigned_user
    end
    
    it "#notify_emails" do
      result = task.notify_emails
      result.length.should eq 2
      
      result[0].should eq(:email => user.email, :user => user)
      result[1].should eq(:email => assigned_user.email, :user => assigned_user)
    end
    
    it "works and sends mail to both owner and assigned users" do
      sign_in admin
      task.assigned_users.count.should eq 1
      
      expect {
        post :create, :comment => {:resource_type => "Task", :resource_id => task.id, :comment => "Test comment"}, :task => {:state => task.state}
        assigns(:comment).errors.to_a.should eq []
      }.to change { ActionMailer::Base.deliveries.count }.by(2)
      
      mail = ActionMailer::Base.deliveries.select{ |mail| mail.to.include?(user.email) }.first
      mail_body = mail.body
      
      puts "Subject: #{mail.subject}"
      mail.subject.should include "Ny kommentar fra: #{admin.name}"
      
      mail_body.should include "<a href=\"#{task_url(task)}\">"
      
      # Ensures the mail is being translated to the users language.
      mail_body.should include "Kommentar"
      mail_body.should include "Hej #{user.name}"
      
      #ActionMailer::Base.deliveries.each do |delivery|
      #  puts "Delivery: #{delivery.inspect}"
      #end
    end
  end
end
