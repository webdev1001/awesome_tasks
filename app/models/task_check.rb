class TaskCheck < ActiveRecord::Base
  belongs_to :task
  belongs_to :user_added, class_name: "User"
  belongs_to :user_assigned, class_name: "User"

  validates_presence_of :task, :name

  after_save :email_user_assigned_if_changed

  scope :checked, -> { where(:checked => true) }

  def send_notifications(task_url)
    task.notify_emails.each do |data|
      TaskChecksMailer.notification(self, data[:user], task_url).deliver!
    end
  end

private

  def email_user_assigned_if_changed
    return unless user_assigned_id_changed?
    delay.send_notification_email
  end

  def send_notification_email
    TaskChecksMailer.notification_assigned(self).deliver!
  end
end
