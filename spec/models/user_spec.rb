require "spec_helper"

describe User do
  context "#users_list" do
    let!(:user){ create :user }
    let!(:project){ create :project }
    let!(:project2){ create :project }
    
    let!(:user1){ create :user }
    let!(:user2){ create :user }
    let!(:user3){ create :user}
    
    before do
      project.users << user
      project.users << user1
      project.users << user2
      project2.users << user3
    end
    
    it "should return a query that works" do
      query = user.visible_users
      query.should be_a ActiveRecord::Relation
      
      query.count.should eq 3
      
      result_array = query.to_a
      result_array.should include user
      result_array.should include user1
      result_array.should include user2
    end
  end
end
