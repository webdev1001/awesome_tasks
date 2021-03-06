require "spec_helper"

describe TaskCheck do
  let(:user){ create :user }
  let(:task_check){ create :task_check }

  before do
    ActionMailer::Base.deliveries.clear
  end

  it "should send notification email when changing assigned user" do
    task_check.user_assigned = user
    task_check.save!

    ActionMailer::Base.deliveries.length.should eq 1

    mail = ActionMailer::Base.deliveries.first
    mail.to.should eq [user.email]
  end

  it "should not send notification email when not changing assigned user" do
    task_check.user_assigned = user
    task_check.save!

    ActionMailer::Base.deliveries.length.should eq 1

    task_check.name = "Something"
    task_check.save!

    ActionMailer::Base.deliveries.length.should eq 1
  end

  it "should send notification email if checked changed" do
    task_check.update_attributes(checked: true)
    ActionMailer::Base.deliveries.length.should eq 1

    task_check.update_attributes(checked: true, name: "test name change")
    ActionMailer::Base.deliveries.length.should eq 1

    task_check.update_attributes(checked: false, name: "test name change")
    ActionMailer::Base.deliveries.length.should eq 2
  end
end
