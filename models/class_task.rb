class Knjtasks::Task < Knj::Datarow
  has_many [
    [:Timelog, :task_id],
    [:Task_assigned_user, :task_id, :assigned_users],
    [:Task_check, :task_id, :checks],
    [:User_task_list_link, :task_id, :user_lists]
  ]
  has_one [
    {:class => :Project, :required => true},
    :User
  ]
  
  def initialize(*args, &blk)
    super(*args, &blk)
    self[:priority] = 1 if self[:priority].to_i <= 0 or self[:priority].to_i > 10
  end
  
  def self.add(d)
    raise _("No project-ID was given.") if d.data[:project_id].to_i <= 0
    raise _("Invalid name was given.") if d.data[:name].to_s.strip.length <= 0
    
    d.data[:user_id] = _site.user.id if _site.user
    d.data[:date_added] = Time.now if !d.data[:date_added]
    d.data[:priority] = 1 if d.data[:priority].to_i <= 0 or d.data[:priority].to_i > 10
    
    begin
      task = d.ob.get(:Project, d.data[:project_id])
    rescue Errno::ENOENT
      raise sprintf(_("A project with the given project-ID could not be found: '%s'."), d.data[:project_id])
    end
  end
  
  def self.type_opts(d)
    return {
      :feature => _("Feature"),
      :bug => _("Bug report"),
      :question => _("Question")
    }
  end
  
  def self.status_opts(d)
    return {
      :open => _("Open"),
      :confirmed => _("Confirmed"),
      :waiting => _("Waiting"),
      :closed => _("Closed")
    }
  end
  
  #Sends a notification about a newly added comment to a task.
  def send_notify_new_comment(comment)
    self.notify_emails.each do |data|
      subj = "#{sprintf(_hb.gettext.gettext("Task #%1$s: %2$s", data[:user].locale), self.id, self.name)} - #{sprintf(_hb.gettext.gettext("New comment from: %s", data[:user].locale), comment.user.name)}"
      
      if !self.user
        user_html = "[#{_hb.gettext.gettext("no user", data[:user].locale)}]"
      else
        user_html = comment.user.name.html
      end
      
      html = ""
      
      html += sprintf(_hb.gettext.gettext("A new comment has been written to the task '%s'.", data[:user].locale), self.name)
      html += "<br /><br />"
      
      html += "<b>#{_hb.gettext.gettext("Author", data[:user].locale)}:</b><br />"
      html += "#{user_html}<br /><br />"
      
      html += "<b>#{_hb.gettext.gettext("Task", data[:user].locale)}:</b><br />"
      html += "<a href=\"#{url}\">#{url}</a><br /><br />"
      
      html += "<b>#{_hb.gettext.gettext("Comment", data[:user].locale)}</b><br />"
      html += comment[:comment]
      
      _hb.mail(:to => data[:email], :subject => subj, :html => html)
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
  
  #Returns the emails of the assigned users and the owner as an array.
  def notify_emails
    emails = {}
    emails[self.user[:email]] = self.user if self.user and self.user[:email].to_s.strip.length > 0
    
    assigned_users.each do |link|
      user = link.user
      next if !user or user[:email].to_s.strip.length <= 0
      
      emails[user[:email]] = user
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
  
  def url
    return "#{_site.args[:url]}/?show=task_show&task_id=#{id}"
  end
  
  def html
    return "<a href=\"?show=task_show&amp;task_id=#{id}\">#{name.html}</a>"
  end
  
  def comments(args = {})
    return _ob.list(:Comment, {"object_lookup" => self}.merge(args))
  end
  
  def has_access?(user = _site.user)
    return false if !user
    return true if user.has_rank?("admin")
    return true if self[:user_id].to_s == user.id.to_s
    return false
  end
  
  def status_str
    return ob.static(:Task, :status_opts)[self[:status].to_sym]
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
end