require "spec_helper"

describe TaskCheck do
  let(:user){ create :user }
  let(:task_check){ create :task_check }

  it "should send notification email when changing assigned user" do
    ActionMailer::Base.deliveries.clear

    task_check.user_assigned = user
    task_check.save!

    ActionMailer::Base.deliveries.length.should eq 1

    mail = ActionMailer::Base.deliveries.first
    mail.to.should eq [user.email]
  end

  it "should not send notification email when not changing assigned user" do
    ActionMailer::Base.deliveries.clear

    task_check.user_assigned = user
    task_check.save!

    ActionMailer::Base.deliveries.length.should eq 1

    task_check.name = "Something"
    task_check.save!

    ActionMailer::Base.deliveries.length.should eq 1
  end
end
