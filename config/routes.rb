AwesomeTasks::Application.routes.draw do
  resources :users do
    get :search, :on => :collection
  end
  
  resources :tasks do
    get :comments, :on => :member
    get :timelogs, :on => :member
    get :users, :on => :member
    post :assign_user, :on => :member
    get :assign_user_choose, :on => :member
    get :checks, :on => :member
  end
  
  resources :task_assigned_users
  
  resources :customers
  resources :projects
  resources :user_authentications do
    delete :logout, :on => :collection
  end
  resources :timelogs
  
  devise_for :users
  
  root 'frontpage#index'
end
