class Task < ActiveRecord::Base
  acts_as_taggable

  has_many :timelogs, dependent: :restrict_with_error
  has_many :task_assigned_users, dependent: :destroy
  has_many :assigned_users, through: :task_assigned_users, source: :user
  has_many :task_checks, dependent: :destroy
  has_many :user_task_list_links, dependent: :destroy
  has_many :uploaded_files, as: :resource, dependent: :destroy
  has_many :comments, as: :resource, dependent: :destroy

  belongs_to :project
  belongs_to :user

  before_save :set_priority
  before_save :set_state

  after_create :assign_users_from_project

  validates_presence_of :user, :project, :name, :task_type, :priority

  scope :related_to_user, lambda{ |user|
    joins("LEFT JOIN task_assigned_users ON task_assigned_users.task_id = tasks.id")
      .where("tasks.user_id = ? || task_assigned_users.user_id = ?", user, user)
      .group("tasks.id")
  }
  scope :not_closed, lambda{ where(state: ["open", "confirmed", "waiting"]) }

  def self.translated_task_types
    return {
      feature: t(".feature"),
      bug: t(".bug_report"),
      question: t(".question"),
      other: t(".other")
    }
  end

  def translated_task_type
    Task.translated_task_types.each do |task_type_i, title|
      return title if task_type_i.to_s == task_type.to_s
    end

    return ""
  end

  def self.translated_states
    return {
      open: t(".open"),
      confirmed: t(".confirmed"),
      waiting: t(".waiting"),
      inactive: t(".inactive"),
      closed: t(".closed")
    }
  end

  def translated_state
    Task.translated_states.each do |state_i, title|
      return title if state.to_s == state_i.to_s
    end

    return ""
  end

  #Sends a notification about a newly added comment to a task.
  def send_notify_new_comment(comment, task_url)
    notify_emails.each do |data|
      TaskAssignedUserMailer.new_comment_notification(comment, data[:user], task_url).deliver!
    end
  end

  # Returns the emails of the assigned users and the owner as an array.
  def notify_emails
    emails = {}
    emails[user.email] = user if user && user.email?

    assigned_users.each do |assigned_user|
      next if !assigned_user || !assigned_user.email?
      emails[assigned_user.email] = assigned_user
    end

    ret = []
    emails.each do |email, user|
      ret << {
        email: email,
        user: user
      }
    end

    return ret
  end

  def name_force
    name.presence || "[#{t(".task_with_id", task_id: id)}]"
  end

  def progress
    return 0 if task_checks.count == 0
    task_checks.checked.count.to_f / task_checks.count.to_f
  end

  def first_email_id
    Digest::MD5.hexdigest("<awesome-tasks-task-#{id}-#{created_at}>")
  end

  def url
    settings = YAML.load_file(Rails.root.join("config", "awesome_tasks.yml"))
    return "#{settings[:domain_url]}/tasks/#{id}"
  end

private

  def set_priority
    self.priority = 1 unless priority
  end

  def set_state
    self.state = "open" unless state
  end

  def assign_users_from_project
    return unless project

    project.autoassigned_users.each do |user|
      assigned_users << user
    end
  end
end
