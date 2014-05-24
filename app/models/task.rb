class Task < ActiveRecord::Base
  has_many :timelogs
  has_many :task_assigned_users
  has_many :assigned_users, :through => :task_assigned_users, :source => :user
  has_many :task_checks
  has_many :user_task_list_links
  has_many :comments, :as => :resource
  
  belongs_to :project
  belongs_to :user
  
  before_save :set_priority
  before_save :set_state
  
  validates_presence_of :task, :user, :project, :name
  
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
    self.notify_emails.each do |data|
      TaskAssignedUserMailer.new_comment_notification(comment, data[:user], task_url).deliver!
    end
  end
  
  # Returns the emails of the assigned users and the owner as an array.
  def notify_emails
    emails = {}
    emails[user.email] = user if user && user.email.present?
    
    assigned_users.each do |assigned_user|
      next if !assigned_user || assigned_user.email.present?
      emails[assigned_user.email] = user
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
  
private
  
  def set_priority
    self.priority = 1 unless priority
  end
  
  def set_state
    self.state = "open" unless state
  end
end
