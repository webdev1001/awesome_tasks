class TaskAssignedUserMailer < ActionMailer::Base
  def notification(task_assigned_user_id, url)
    task_assigned_user = TaskAssignedUser.find(task_assigned_user_id)

    @user = task_assigned_user.user
    @user_assigned_by = task_assigned_user.user_assigned_by
    @task_url = url
    @task = task_assigned_user.task

    I18n.with_locale @user.locale! do
      subject = "[#{@task.project.name}] "
      subject << t(".you_have_been_assigned_to"), task_assigned_user.task.name)
      mail(to: @user.email, subject: subject, message_id: @task.first_email_id)
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
      subject << t(".new_comment_from_author", author_name: @author.name)

      mail(
        to: user.email,
        from: "#{comment.user.name} <#{from_email}>",
        subject: subject,
        in_reply_to: @comment.resource.first_email_id
      )
    end
  end

private

  def from_email
    Rails.application.config.action_mailer.default_options[:from]
  end
end
