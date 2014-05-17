namespace :migrate_database do
  task :execute => :environment do
    require "mysql"
    db = Baza::Db.new(
      :type => "mysql",
      :subtype => :mysql,
      :host => ENV["DB_HOST"],
      :user => ENV["DB_USER"],
      :pass => ENV["DB_PASSWD"],
      :db => ENV["DB_DB"]
    )
    
    db.select("User", nil, "orderby" => "id") do |user_orig|
      puts "Migrating user #{user_orig[:id]}"
      user = User.find_or_initialize_by(:id => user_orig[:id])
      MigrateHelper.assign(user_orig, user, {
        :name => :name,
        :username => :username,
        :passwd=> :encrypted_password,
        :email => :email,
        :locale => :locale,
        :active => :active
      })
    end
    
    db.select("Customer", nil, "orderby" => "id") do |customer_orig|
      puts "Migrating customer #{customer_orig[:id]}"
      customer = Customer.find_or_initialize_by(:id => customer_orig[:id])
      MigrateHelper.assign(customer_orig, customer, {
        :name => :name,
        :date_added => :created_at
      })
    end
    
    db.select("Project", nil, "orderby" => "id") do |project_orig|
      puts "Migrating project #{project_orig[:id]}"
      project = Project.find_or_initialize_by(:id => project_orig[:id])
      MigrateHelper.assign(project_orig, project, {
        :name => :name,
        :customer_id => :customer_id,
        :descr => :description,
        :added_date => :created_at,
        :added_user_id => :user_added_id,
        :date_deadline => :deadline_at,
        :price_per_hour => :price_per_hour,
        :price_per_hour_transport => :price_per_hour_transport
      })
    end
    
    db.select("Task", nil, "orderby" => "id") do |task_orig|
      puts "Migrating task #{task_orig[:id]}"
      task = Task.find_or_initialize_by(:id => task_orig[:id])
      MigrateHelper.assign(task_orig, task, {
        :project_id => :project_id,
        :user_id => :user_id,
        :name => :name,
        :descr => :description,
        :type => :task_type,
        :status => :state,
        :priority => :priority,
        :date_added => :created_at
      })
    end
    
    db.select("Timelog", nil, "orderby" => "id") do |timelog_orig|
      puts "Migrating timelog #{timelog_orig[:id]}"
      timelog = Timelog.find_or_initialize_by(:id => timelog_orig[:id])
      MigrateHelper.assign(timelog_orig, timelog, {
        :task_id => :task_id,
        :user_id => :user_id,
        :date => :date,
        :time => :time,
        :time_transport => :time_transport,
        :transport_length => :transport_length,
        :comment => :comment,
        :invoiced => :invoiced,
        :invoiced_date => :invoiced_at,
        :invoiced_user_id => :invoiced_by_user_id
      })
    end
  end
end
