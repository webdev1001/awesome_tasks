namespace :production do
  task "safe_db" => :environment do
    ActiveRecord::Base.connection.execute("UPDATE `users` SET `email` = CONCAT('development-user-', users.id, '@awesometasks.org')")
  end
end
