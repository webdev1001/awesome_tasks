source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
gem 'mysql2', platform: :ruby
gem 'activerecord-jdbc-adapter', platform: :jruby
gem 'jdbc-mysql', platform: :jruby
gem 'sass-rails', '~> 4.0.5'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.0.4'
gem 'devise'
gem 'devise-encryptable'
gem 'simple_form'
gem 'simple_form_ransack', '~> 0.0.7'
gem 'php4r'
gem 'knjrbfw', '>= 0.0.113'
gem 'activerecord-session_store'
gem 'cancancan'
gem 'paperclip'
gem 'ckeditor'
gem 'jquery-migrate-rails'
gem 'datet'
gem 'ransack'
gem 'haml-rails'
gem 'baza'
gem 'email_validator'
gem 'rails_imager', '0.0.29'
gem 'will_paginate'
gem 'agent_helpers', '~> 0.0.5'
gem 'whenever', require: false
gem 'acts-as-taggable-on'
gem 'state_machines-activerecord'
gem 'public_activity'
gem 'light_mobile', '~> 0.0.11'
gem 'rmagick', platform: :ruby
gem 'rmagick4j', platform: :jruby
gem 'csv_lazy', '~> 0.0.9'
gem 'awesome_translations', '~> 0.0.24'

# For handeling internationalized amount formats.
gem 'autonumeric-rails'

# PDF generation.
gem 'pdfkit'
gem 'wkhtmltopdf-binary'

# Delayed job
gem 'delayed_job_active_record'
gem 'daemons'

# Used for migrate script (the old database to Rails)
gem 'mysql', platform: :ruby, require: false
gem 'active-record-transactioner', '0.0.5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test do
  gem "codeclimate-test-reporter", group: :test, require: nil
end

group :development do
  # Use Capistrano for deployment
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  #gem 'capistrano-rvm'
  gem 'pry'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'forgery'
end
