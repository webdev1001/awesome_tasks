# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, 'awesome_tasks'
set :repo_url, 'https://github.com/kaspernj/awesome_tasks.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/smtp.yml config/smtp_defaults.yml config/smtp_default_url_options.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :rvm_ruby_version, '2.1.2'

set :whenever_roles,        ->{ :db }
set :whenever_command,      ->{ [:bundle, :exec, :whenever] }
set :whenever_command_environment_variables, ->{ {} }
set :whenever_identifier,   ->{ fetch :application }
set :whenever_environment,  ->{ fetch :rails_env, "production" }
set :whenever_variables,    ->{ "environment=#{fetch :whenever_environment}" }
set :whenever_update_flags, ->{ "--update-crontab #{fetch :whenever_identifier} --set #{fetch :whenever_variables}" }
set :whenever_clear_flags,  ->{ "--clear-crontab #{fetch :whenever_identifier}" }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence do
      execute :sudo, "apache2ctl graceful"

      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, 'bin/delayed_job', :restart
        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
