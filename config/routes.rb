AwesomeTasks::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  mount RailsImager::Engine => "/rails_imager"
  devise_for :users, encryptor: :md5

  resources :comments
  resources :invoices do
    get :pdf, on: :member
    resources :invoice_lines
  end

  resources :uploaded_files

  resources :users do
    get :search, on: :collection
    post :log_in_as, on: :member
    get :roles, on: :member
  end

  resources :user_roles

  resources :tasks do
    get :comments, on: :member
    get :timelogs, on: :member
    get :users, on: :member
    post :assign_user, on: :member
    get :assign_user_choose, on: :member
    get :checks, on: :member

    resources :task_checks
  end

  resources :task_assigned_users

  resources :organizations

  resources :projects do
    get :assigned_users, on: :member
    post :assign_user, on: :member

    resources :project_autoassigned_users
  end

  resources :user_authentications do
    delete :logout, on: :collection
  end

  namespace :profile do
    get :index
    patch :update
  end

  namespace :workstatus do
    get :index
  end

  namespace :locales do
    post :set
  end

  resources :user_project_links
  resources :user_task_list_links

  resources :timelogs do
    post :mark_invoiced, on: :collection
  end

  root 'frontpage#index'
end
