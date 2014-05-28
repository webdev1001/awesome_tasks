class GettextSimpleRails::MonthNames
  def translations
    #. Default value: Invalid record: %{errors}
    _('activerecord.errors.messages.record_invalid')
    #. Default value: cannot be blank
    _('activerecord.errors.models.user.attributes.email.blank')
    #. Default value: has already been taken
    _('activerecord.errors.models.user.attributes.email.taken')
    #. Default value: is invalid
    _('activerecord.errors.models.user.attributes.email.invalid')
    #. Default value: cannot be blank
    _('activerecord.errors.models.user.attributes.password.blank')
    #. Default value: is too short. The minimum is %{count}
    _('activerecord.errors.models.user.attributes.password.too_short')
    #. Default value: is too long. The maximum is %{count}
    _('activerecord.errors.models.user.attributes.password.too_long')
    #. Default value: cannot be blank
    _('activerecord.errors.models.comment.attributes.resource.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.comment.attributes.comment.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.comment.attributes.user.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.project.attributes.customer.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.task.attributes.user.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.task.attributes.project.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.task.attributes.name.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.task_assigned_user.attributes.task.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.task_assigned_user.attributes.user.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.task_check.attributes.task.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.timelog.attributes.task.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.timelog.attributes.user.blank')
    #. Default value: has already been taken
    _('activerecord.errors.models.user_project_link.attributes.user.taken')
    #. Default value: cannot be blank
    _('activerecord.errors.models.user_role.attributes.user.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.user_role.attributes.role.blank')
    #. Default value: has already been taken
    _('activerecord.errors.models.user_role.attributes.role.taken')
    #. Default value: cannot be blank
    _('activerecord.errors.models.user_task_list_link.attributes.user.blank')
    #. Default value: cannot be blank
    _('activerecord.errors.models.user_task_list_link.attributes.task.blank')
  end
end
