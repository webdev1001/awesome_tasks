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

      can :manage, UploadedFile do |uploaded_file|
        can? :show, uploaded_file.resource
      end

      @current_user.user_roles.each do |role|
        __send__(role.role)
      end
    end
  end

private

  def administrator
    can :admin, :admin
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
    can [:new, :create], Task
    can :manage, TaskCheck do |task_check|
      can? :show, task_check.task
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

    can [:edit, :update, :show, :checks, :users, :comments, :timelogs, :destroy, :assign_user], Task do |task|
      access = false

      if task.task_assigned_users.where(user_id: @current_user.id).any?
        access = true
      elsif task.project && @current_user.user_project_links.where(project_id: task.project.id).any?
        access = true
      elsif task.user == @current_user
        access = true
      end

      access
    end
  end

  def users_access
    can :search, User
  end
end
