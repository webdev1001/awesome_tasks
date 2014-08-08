class TaskCheck < ActiveRecord::Base
  belongs_to :task
  belongs_to :user_added, class_name: "User"
  belongs_to :user_assigned, class_name: "User"

  validates_presence_of :task, :name

  def send_notifications(task_url)
    task.notify_emails.each do |data|
      TaskChecksMailer.notification(self, data[:user], task_url).deliver!
    end
  end
end
