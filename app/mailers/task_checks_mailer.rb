class TaskChecksMailer < ActionMailer::Base
  helper :task

  def notification task_check, user, task_url, user_changed
    @task_check = task_check
    @task = @task_check.task
    @task_url = task_url
    @user = user

    I18n.with_locale @user.locale! do
      if @task_check.checked?
        subject_text = _("completed")
      else
        subject_text = _("not completed")
      end

      subject = "[#{@task.project.name}] "
      subject << "'#{@task_check.name}' #{subject_text}"

      mail(
        to: user.email,
        from: "#{user_changed.name} <#{from_email}>",
        subject: subject,
        in_reply_to: @task.first_email_id
      )
    end
  end

  def notification_assigned task_check, user_assigner
    @task_check = task_check
    @task = @task_check.task
    @user = @task_check.user_assigned

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
