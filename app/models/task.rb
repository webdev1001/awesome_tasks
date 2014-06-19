class Task < ActiveRecord::Base
  has_many :timelogs, :dependent => :restrict_with_error
  has_many :task_assigned_users, :dependent => :destroy
  has_many :assigned_users, :through => :task_assigned_users, :source => :user
  has_many :task_checks, :dependent => :destroy
  has_many :user_task_list_links, :dependent => :destroy
  has_many :comments, :as => :resource, :dependent => :destroy
  
  belongs_to :project
  belongs_to :user
  
  before_save :set_priority
  before_save :set_state
  
  validates_presence_of :user, :project, :name, :task_type, :priority
  
  scope :related_to_user, lambda{ |user|
    joins("LEFT JOIN task_assigned_users ON task_assigned_users.task_id = tasks.id")
      .where("tasks.user_id = ? || task_assigned_users.user_id = ?", user, user)
      .group("tasks.id")
  }
  scope :not_closed, lambda{ where(:state => ["open", "confirmed", "waiting"]) }
  
  def self.translated_task_types
    return {
      :feature => _("Feature"),
      :bug => _("Bug report"),
      :question => _("Question"),
      :other => _("Other")
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
      :open => _("Open"),
      :confirmed => _("Confirmed"),
      :waiting => _("Waiting"),
      :inactive => _("Inactive"),
      :closed => _("Closed")
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
    emails[user.email] = user if user && user.email.present?
    
    assigned_users.each do |assigned_user|
      next if !assigned_user || !assigned_user.email.present?
      emails[assigned_user.email] = assigned_user
    end
    
    ret = []
    emails.each do |email, user|
      ret << {
        :email => email,
        :user => user
      }
    end
    
    return ret
  end
  
  def name_force
    name.presence || "[#{_("task %{task_id}", :task_id => id)}]"
  end
  
private
  
  def set_priority
    self.priority = 1 unless priority
  end
  
  def set_state
    self.state = "open" unless state
  end
end
