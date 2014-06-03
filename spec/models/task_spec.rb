require "spec_helper"

describe Task do
  context "#related_for_user" do
    let!(:user){ create :user }
    let!(:task_owned){ create :task, :user => user }
    let!(:task_not_owned){ create :task }
    
    it "should find the right tasks" do
      list = Task.related_to_user(user).to_a
      list.should include task_owned
      list.should_not include task_not_owned
    end
  end
  
  context "#not_closed" do
    let!(:task_confirmed){ create :task, :state => "confirmed" }
    let!(:task_open){ create :task, :state => "open" }
    let!(:task_waiting){ create :task, :state => "waiting" }
    let!(:task_closed){ create :task, :state => "closed" }
    
    it "find the right tasks" do
      list = Task.not_closed
      list.should include task_confirmed
      list.should include task_open
      list.should include task_waiting
      list.should_not include task_closed
    end
  end
end
