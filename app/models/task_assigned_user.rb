class TaskAssignedUser < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  belongs_to :user_assigned_by, class_name: "User"

  validates_presence_of :task, :user

  def send_notify(url)
    return false unless user.email?
    TaskAssignedUserMailer.notification(id, url).deliver!
  end
end
