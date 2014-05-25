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
  
  def self.add(d)
    raise _("No project-ID was given.") if d.data[:project_id].to_i <= 0
    raise _("Invalid name was given.") if d.data[:name].to_s.strip.length <= 0
    
    d.data[:user_id] = current_user.id if current_user
    d.data[:date_added] = Time.now if !d.data[:date_added]
    d.data[:priority] = 1 if d.data[:priority].to_i <= 0 or d.data[:priority].to_i > 10
    
    begin
      task = d.ob.get(:Project, d.data[:project_id])
    rescue Errno::ENOENT
      raise sprintf(_("A project with the given project-ID could not be found: '%s'."), d.data[:project_id])
    end
  end
  
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
    notify_emails.each do |data|
      TaskAssignedUserMailer.new_comment_notification(comment, data[:user], task_url).deliver!
    end
  end
  
  #Sends a 
  def send_notify_assigned(user_assigned, user_by)
    return false if user_assigned[:email].to_s.strip.length <= 0
    
    subj = sprintf(_hb.gettext.gettext("You have been assigned to: %s", user_assigned.locale), self.name)
    
    html = ""
    
    html += "<b>#{_hb.gettext.gettext("Assigned by", user_assigned.locale)}:</b><br />"
    html += "#{user_by.name}<br /><br />"
    
    html += "<b>#{_hb.gettext.gettext("Task", user_assigned.locale)}:</b><br />"
    html += "<a href=\"#{url}\">#{url}</a><br /><br />"
    
    html += "<b>#{_hb.gettext.gettext("Description", user_assigned.locale)}</b><br />"
    html += self[:descr]
    
    _hb.mail(:to => user_assigned[:email], :subject => subj, :html => html)
  end
  
  # Returns the emails of the assigned users and the owner as an array.
  def notify_emails
    emails = {}
    emails[user.email] = user if user && user.email.present?
    
    assigned_users.each do |assigned_user|
      next if !assigned_user || !assigned_user.email.present?
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
  
  def has_access?(user)
    return false if !user
    return true if user.user_roles.where(:role => "administrator").any?
    return true if self[:user_id].to_s == user.id.to_s
    return false
  end
  
  def has_view_access?(user)
    return false if !user
    return true if self.has_access?(user)
    
    task_link = ob.get_by(:Task_assigned_user, {
      "user" => user,
      "task" => self
    })
    return true if task_link
    
    project_link = ob.get_by(:User_project_link, {
      "user" => user,
      "project" => self.project
    })
    return true if project_link
    
    return false
  end
  
private
  
  def set_priority
    self.priority = 1 unless priority
  end
  
  def set_state
    self.state = "open" unless state
  end
end
