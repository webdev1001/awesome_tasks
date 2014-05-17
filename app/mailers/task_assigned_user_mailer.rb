class TaskAssignedUserMailer < ActionMailer::Base
  def notification(task_assigned_user_id, url)
    task_assigned_user = TaskAssignedUser.find(task_assigned_user_id)
    
    I18n.with_locale task_assigned_user.user_assigned_by.locale do
      subj = sprintf(_("You have been assigned to: %s"), task_assigned_user.task.name)
      
      html = ""
      
      html << "<b>#{_("Assigned by")}:</b><br />"
      html << "#{task_assigned_user.user_assigned_by.name}<br /><br />"
      
      html << "<b>#{_("Task")}:</b><br />"
      html << "<a href=\"#{url}\">#{url}</a><br /><br />"
      
      html << "<b>#{_("Description")}</b><br />"
      html << task_assigned_user.task.description.to_s
      
      mail(:to => task_assigned_user.user.email, :subject => subj) do |format|
        format.html { html }
      end
    end
  end
end
