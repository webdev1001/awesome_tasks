class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user
      can :show, User do |user|
        projects = user.projects
      end
      
      task_access(current_user)
      ckeditor_access(current_user)
      comment_access(current_user)
      
      current_user.user_roles.each do |role|
        __send__(role.role)
      end
    end
  end
  
private
  
  def administrator
    can :admin, :admin
    can :manage, Comment
    can :manage, Customer
    can :manage, Project
    can :manage, Task
    can :manage, User
    can :manage, UserTaskListLink
    can :manage, Timelog
    can :manage, UserRole
  end
  
  def customer_administrator
    
  end
  
  def comment_access(current_user)
    can [:new, :create, :show], Comment
    can [:edit, :update, :destroy], Comment do |comment|
      comment.user_id == current_user.id
    end
  end
  
  def ckeditor_access(current_user)
    can :access, :ckeditor
    can :manage, Ckeditor::Asset
    can :manage, Ckeditor::AttachmentFile
    can :manage, Ckeditor::Picture
  end
  
  def task_access(current_user)
    can :create, UserTaskListLink
    can [:edit, :update, :destroy], UserTaskListLink do |user_task_list_link|
      user_task_list_link.user_id = current_user.id
    end
    
    can :show, Task do |task|
      access = false
      
      if task.task_assigned_users.where(:user => current_user).any?
        access = true
      elsif task.project && current_user.user_project_links.where(:project => task.project).any?
        access = true
      elsif task.user == current_user
        access = true
      end
      
      access
    end
  end
end
