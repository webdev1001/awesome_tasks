require "spec_helper"

describe TasksController do
  let!(:admin){ create :user_admin }
  let!(:task){ create :task, :user => admin }
  let(:user){ create :user }
  let(:project){ create :project }
  
  render_views
  
  context "auto assigns users" do
    it "assigns users automatically" do
      sign_in admin
      project.autoassigned_users << user
      post :create, :task => {:name => "Test", :project_id => project.id, :priority => 1, :task_type => "feature"}
      controller.flash[:error].should eq nil
      task = Task.last
      response.location.should eq task_url(task)
      task.assigned_users.to_a.should include user
    end
  end
  
  context "#assign_user" do
    let(:user_to_be_assigned){ create :user }
    
    it "#assign_user" do
      sign_in admin
      
      expect {
        post(:assign_user, {
          :id => task.id,
          :user_id => user_to_be_assigned.id
        })
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
      mail = ActionMailer::Base.deliveries.last
      mail.body.should include task_url(task)
      mail.body.should include user_to_be_assigned.name
      mail.body.should include admin.name
      
      mail.subject.should include "[#{task.project.name}]"
      
      # puts ActionMailer::Base.deliveries.last.body
    end
  end
  
  context "#show" do
    let!(:task_access){ create :task, :user => user }
    let!(:task_no_access){ create :task }
    let!(:task_assigned){ create :task }
    
    before do
      sign_in user
      task_assigned.assigned_users << user
    end
    
    it "shows tasks that the user have access to" do
      get :show, :id => task_access.id
      response.should be_success
    end
    
    it "doesnt show tasks that the user doesnt have access to" do
      request.env["HTTP_REFERER"] = root_url
      
      expect{
        get :show, :id => task_no_access.id
      }.to raise_error CanCan::AccessDenied
    end
  end
  
  context "#edit" do
    let(:task_access){ create :task, :user => user }
    let(:task_no_access){ create :task }
    let(:task_with_timelogs){ create :task, :user => user }
    let(:timelog){ create :timelog, :task => task_with_timelogs }
    
    before do
      sign_in user
    end
    
    it "can edit own tasks" do
      get :edit, :id => task_access.id
      response.should be_success
    end
    
    it "can edit assigned tasks" do
      task_no_access.assigned_users << user
      get :edit, :id => task_no_access.id
      response.should be_success
    end
    
    it "cannot edit other tasks" do
      expect {
        get :edit, :id => task_no_access.id
      }.to raise_error CanCan::AccessDenied
    end
    
    it "cannot destroy tasks with timelogs" do
      timelog #creates the timelog.
      delete :destroy, :id => task_with_timelogs.id
      response.should redirect_to task_path(task_with_timelogs)
      controller.flash[:error].should_not eq nil
    end
  end
end
