class TaskAssignedUserMailer < ActionMailer::Base
  def notification(task_assigned_user_id, url)
    task_assigned_user = TaskAssignedUser.find(task_assigned_user_id)

    @user = task_assigned_user.user
    @user_assigned_by = task_assigned_user.user_assigned_by
    @task_url = url
    @task = task_assigned_user.task

    I18n.with_locale @user.locale! do
      subject = "[#{@task.project.name}] "
      subject << sprintf(_("You have been assigned to: %s"), task_assigned_user.task.name)
      mail(to: @user.email, subject: subject)
    end
  end

  def new_comment_notification(comment, user, task_url)
    @comment = comment
    @task = @comment.resource
    @author = @comment.user
    @user = user
    @task_url = task_url

    I18n.with_locale user.locale! do
      subject = "[#{@task.project.name}] #{sprintf(_("Task #%1$s: %2$s"), @task.id, @task.name)} - "
      subject << _("New comment from: %{author_name}", author_name: @author.name)

      mail(to: user.email, subject: subject)
    end
  end
end
