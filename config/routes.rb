AwesomeTasks::Application.routes.draw do
  mount AwesomeTranslations::Engine => "/awesome_translations" if Rails.env.development?
  mount Ckeditor::Engine => '/ckeditor'
  mount RailsImager::Engine => "/rails_imager"
  devise_for :users, encryptor: :md5

  resources :accounts do
    resources :account_imports do
      post :update_columns, on: :member
      post :execute, on: :member
    end

    resources :account_lines
  end

  resources :account_lines, only: :index

  resources :comments, except: [:show, :index]
  resources :invoices do
    member do
      get :pdf

      post :finish
      post :register_as_sent
      post :register_as_paid
      post :add_uninvoiced_timelogs
    end

    resources :invoice_lines, except: [:index]
  end

  resources :invoice_groups
  resources :uploaded_files

  resources :users do
    get :search, on: :collection
    post :log_in_as, on: :member
    get :roles, on: :member
  end

  resources :user_roles, except: [:show, :index]
  resources :tags, only: [:create, :destroy]

  resources :tasks do
    get :comments, on: :member
    get :timelogs, on: :member
    get :users, on: :member
    post :assign_user, on: :member
    get :assign_user_choose, on: :member
    get :checks, on: :member

    resources :task_checks, except: [:show, :index]
  end

  resources :task_assigned_users, only: [:new, :create, :destroy]
  resources :organizations

  resources :projects do
    get :assigned_users, on: :member
    post :assign_user, on: :member

    resources :project_autoassigned_users, only: [:new, :create, :destroy]
  end

  namespace :profile do
    get :index
    patch :update
  end

  namespace :workstatus do
    get :index
  end

  resources :locales, only: [:new, :create]

  resources :user_project_links, only: [:new, :create, :destroy]
  resources :user_task_list_links, only: [:create, :destroy]

  resources :timelogs do
    post :mark_invoiced, on: :collection
  end

  root 'frontpage#index'
end
