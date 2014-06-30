require "spec_helper"

describe TimelogsController do
  render_views
  
  let(:task){ create :task }
  let(:timelog){ create :timelog, :task => task }
  let(:admin){ create :user_admin }
  
  before do
    sign_in admin
  end
  
  it "#new" do
    get :new, :task_id => task.id
    response.code.should eq "200"
  end
  
  it "#edit" do
    get :edit, :task_id => task.id, :id => timelog.id
    response.code.should eq "200"
  end
  
  it "#destroy" do
    delete :destroy, :task_id => task.id, :id => timelog.id
    response.code.should eq "200"
  end
  
  it "#update" do
    patch :update, :task_id => task.id, :id => timelog.id, :timelog => {:description => Forgery(:lorem_ipsum).words(5) }
    response.code.should eq "200"
  end
  
  context "#index" do
    context "finds timelogs where invoiced is 0" do
      let!(:timelog_invoiced_0){ create :timelog, :invoiced => 0 }
      let!(:timelog_invoiced_nil){ create :timelog, :invoiced => nil }
      
      it "works" do
        get :index, :timelog => {:invoiced => "only_not_invoiced"}
        assigns(:timelogs).should include timelog_invoiced_0
        assigns(:timelogs).should include timelog_invoiced_nil
      end
    end
  end
end
