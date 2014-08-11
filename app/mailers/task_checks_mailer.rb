class TaskChecksMailer < ActionMailer::Base
  helper :task

  def notification(task_check, user, task_url)
    @task_check = task_check
    @task = @task_check.task
    @task_url = task_url
    @user = user

    I18n.with_locale @user.locale! do
      subject = "[#{@task.project.name}] "
      subject << _("'%{task_check_name}' completed", task_check_name: @task_check.name)

      mail(to: user.email, subject: subject)
    end
  end

  def notification_assigned(task_check)
    @task_check = task_check
    @task = @task_check.task
    @user = @task_check.user_assigned

    I18n.with_locale @user.locale! do
      subject = "[#{@task.project.name}] "
      subject << _("Assigned to check: %{check_name}", check_name: @task_check.name)

      mail to: @user.email, subject: subject
    end
  end
end
