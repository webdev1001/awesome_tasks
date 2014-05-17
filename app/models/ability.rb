class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      user.user_roles.each do |role|
        __send__(role.role)
      end
      
      can :show, Task do |task|
        access = false
        
        if task.task_assigned_users.where(:user_id => user.id).any?
          access = true
        elsif task.project && user.user_project_links.where(:project_id => task.project.id).any?
          access = true
        elsif task.user == user
          access = true
        end
        
        access
      end
      
      can :show, User
    end
  end
  
private
  
  def administrator
    can :admin, :admin
    can :manage, Task
  end
end
