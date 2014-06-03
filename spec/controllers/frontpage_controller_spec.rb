require "spec_helper"

describe FrontpageController do
  render_views
  
  context "should redirect to new urls when using old ones" do
    let!(:user){ create :user }
    let!(:task){ create :task }
    
    it "should redirect to new urls" do
      sign_in user
      get :index, :show => "tasks_show", :id => task.id
      response.location.should eq task_url(task)
    end
  end
end
