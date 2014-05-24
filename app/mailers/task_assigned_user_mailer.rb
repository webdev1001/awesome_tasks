class TaskAssignedUserMailer < ActionMailer::Base
  def notification(task_assigned_user_id, url)
    task_assigned_user = TaskAssignedUser.find(task_assigned_user_id)
    
    @user = task_assigned_user.user
    @user_assigned_by = task_assigned_user.user_assigned_by
    @task_url = url
    @task = task_assigned_user.task
    
    I18n.with_locale task_assigned_user.user_assigned_by.locale! do
      subject = sprintf(_("You have been assigned to: %s"), task_assigned_user.task.name)
      mail(:to => task_assigned_user.user.email, :subject => subject)
    end
  end
  
  def new_comment_notification(comment, user, task_url)
    @comment = comment
    @task = @comment.resource
    @author = @comment.user
    @user = user
    @task_url = task_url
    
    I18n.with_locale user.locale! do
      subject = "#{sprintf(_("Task #%1$s: %2$s"), @task.id, @task.name)} - #{sprintf(_("New comment from: %s"), @user.name)}"
      mail(:to => user.email, :subject => subject)
    end
  end
end
