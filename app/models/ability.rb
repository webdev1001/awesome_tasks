class Ability
  include CanCan::Ability

  def initialize(current_user)
    @current_user = current_user

    if @current_user
      can :show, User do |user|
        projects = user.projects
      end

      task_access
      ckeditor_access
      comment_access
      users_access

      @current_user.user_roles.each do |role|
        __send__(role.role)
      end
    end
  end

private

  def administrator
    can :admin, :admin
    can :manage, Account
    can :manage, AccountImport
    can :manage, AccountLine
    can :manage, Comment
    can :manage, Organization
    can :manage, Comment
    can :manage, Invoice
    can :manage, InvoiceGroup
    can :manage, InvoiceLine
    can :manage, Project
    can :manage, ProjectAutoassignedUser
    can :manage, Task
    can :manage, UploadedFile
    can :manage, User
    can :manage, UserProjectLink
    can :manage, UserTaskListLink
    can :manage, Timelog
    can :manage, UserRole
  end

  def organization_administrator
  end

  def comment_access
    can [:new, :create, :show], Comment
    can [:edit, :update, :destroy], Comment do |comment|
      comment.user_id == @current_user.id
    end
  end

  def ckeditor_access
    can :access, :ckeditor
    can :manage, Ckeditor::Asset
    can :manage, Ckeditor::AttachmentFile
    can :manage, Ckeditor::Picture
  end

  def task_access
    can :manage, TaskCheck do |task_check|
      if task_check.task
        can? :show, task_check.task
      else
        true
      end
    end
    can :manage, TaskAssignedUser do |task_assigned_user|
      if task_assigned_user.task
        can? :edit, task_assigned_user.task
      else
        true
      end
    end
    can :create, UserTaskListLink
    can [:edit, :update, :destroy], UserTaskListLink do |user_task_list_link|
      user_task_list_link.user_id = @current_user.id
    end

    can [:new, :create], Task
    can [:index, :edit, :update, :show, :checks, :users, :comments, :timelogs, :assign_user], Task, user_id: @current_user.id
    can [:index, :edit, :update, :show, :checks, :users, :comments, :timelogs, :assign_user], Task, project_id: @current_user.projects.select(:id).map(&:id)
    can [:index, :edit, :update, :show, :checks, :users, :comments, :timelogs, :assign_user], Task, task_assigned_users: {task_id: @current_user.assigned_tasks.select(:id).map(&:id)}

    can [:index, :show], UploadedFile, resource_type: 'Task', resource_id: Task.joins(:task_assigned_users).accessible_by(self)
  end

  def users_access
    can :search, User
  end
end
