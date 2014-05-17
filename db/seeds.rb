# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

customer = Customer.find_or_initialize_by(:name => "Test Customer")
customer.save!

project = Project.find_or_initialize_by(:name => "Test Project")
project.save!

user_admin = User.find_or_initialize_by(:username => "admin", :email => "admin@example.com")
user_admin.assign_attributes(
  :encrypted_password => Digest::MD5.hexdigest("password"),
  :active => true,
  :locale => :en
)
user_admin.save!

user_admin.user_roles.find_or_initialize_by(:role => "administrator").save!

task = Task.find_or_initialize_by(:name => "Test task")
task.assign_attributes(
  :user => user_admin,
  :project => project
)
task.save!

timelog1 = task.timelogs.find_or_initialize_by(:date => "2014-06-17")
timelog1.assign_attributes(
  :time => "1:30:00",
  :user => user_admin
)
timelog1.save!

timelog2 = task.timelogs.find_or_initialize_by(:date => "2014-06-18")
timelog2.assign_attributes(
  :time => "0:30:00",
  :user => user_admin
)
timelog2.save!
