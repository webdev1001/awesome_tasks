class TaskChecksMailer < ActionMailer::Base
  helper :task

  def notification_checked(task_check, user)
    @task_check = task_check
    @task = @task_check.task
    @user = user

    I18n.with_locale @user.locale! do
      if @task_check.checked?
        subject_text = _("completed")
      else
        subject_text = _("not completed")
      end

      subject = "[#{@task.project.name}] "
      subject << "'#{@task_check.name}' #{subject_text}"

      mail_args = {
        to: user.email,
        subject: subject,
        in_reply_to: @task.first_email_id
      }

      if @task_check.user_checked
        mail_args[:from] = "#{@task_check.user_checked.name} <#{from_email}>"
      end

      mail(mail_args)
    end
  end

  def notification_assigned(task_check, user_assigned)
    user_assigner = task_check.user_assigner || task_check.user_added
    @task_check = task_check
    @task = @task_check.task
    @user = user_assigned

    I18n.with_locale @user.locale! do
      subject = "[#{@task.project.name}] "
      subject << _("Assigned to check: %{check_name}", check_name: @task_check.name)

      mail(
        to: @user.email,
        from: "#{user_assigner.name} <#{from_email}>",
        subject: subject,
        in_reply_to: @task.first_email_id
      )
    end
  end

private

  def from_email
    Rails.application.config.action_mailer.default_options[:from]
  end
end
