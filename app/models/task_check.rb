class TaskCheck < ActiveRecord::Base
  belongs_to :task
  belongs_to :user_added, class_name: "User"
  belongs_to :user_assigned, class_name: "User"
  belongs_to :user_assigner, class_name: "User"
  belongs_to :user_checked, class_name: "User"

  validates_presence_of :task, :name

  after_save :email_user_assigned_if_changed
  after_save :email_users_if_checked_changed
  before_save :remove_user_checked_if_not_checked
  before_save :remove_user_assigner_if_unassigned

  scope :checked, -> { where(checked: true) }

private

  def email_user_assigned_if_changed
    return unless user_assigned_id_changed?

    user = user_assigned
    user = User.where(id: user_assigned_id_was).first unless user

    delay.send_notification_assigned_email(user)
  end

  def send_notification_assigned_email(user)
    TaskChecksMailer.notification_assigned(self, user).deliver_later!
  end

  def email_users_if_checked_changed
    return unless checked_changed?
    delay.send_notification_checked_email
  end

  def send_notification_checked_email
    task.notify_emails.each do |data|
      TaskChecksMailer.notification_checked(self, data[:user]).deliver_later!
    end
  end

  def remove_user_checked_if_not_checked
    self.user_checked = nil unless checked?
  end

  def remove_user_assigner_if_unassigned
    self.user_assigner = nil unless user_assigned
  end
end
