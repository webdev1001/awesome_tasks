namespace :migrate_database do
  task execute: :environment do
    require "mysql"
    db = Baza::Db.new(
      type: "mysql",
      subtype: :mysql,
      host: ENV["DB_HOST"],
      user: ENV["DB_USER"],
      pass: ENV["DB_PASSWD"],
      db: ENV["DB_DB"]
    )

    ActiveRecordTransactioner.new(
      transaction_size: 1000,
      debug: false,
      max_running_threads: 5,
      call_args: [validate: false]
    ) do |transactioner|
      db.select("User", nil, "orderby" => "id") do |user_orig|
        puts "Migrating user #{user_orig[:id]}"
        user = User.find_or_initialize_by(id: user_orig[:id])

        locale_match = user_orig[:locale].to_s.match(/^([a-z]{2})_[A-Z]{2}$/)
        if locale_match
          user.locale = locale_match[1]
        else
          user.locale = "da"
        end

        MigrateHelper.assign(user_orig, user, transactioner, {
          name: :name,
          username: :username,
          :passwd=> :encrypted_password,
          email: :email,
          active: :active
        })
      end

      db.select("Organization", nil, "orderby" => "id") do |organization_orig|
        puts "Migrating organization #{organization_orig[:id]}"
        organization = Organization.find_or_initialize_by(id: organization_orig[:id])
        MigrateHelper.assign(organization_orig, organization, transactioner, {
          name: :name,
          date_added: :created_at
        })
      end

      db.select("Project", nil, "orderby" => "id") do |project_orig|
        puts "Migrating project #{project_orig[:id]}"
        project = Project.find_or_initialize_by(id: project_orig[:id])
        MigrateHelper.assign(project_orig, project, transactioner, {
          name: :name,
          organization_id: :organization_id,
          descr: :description,
          added_date: :created_at,
          added_user_id: :user_added_id,
          date_deadline: :deadline_at,
          price_per_hour: :price_per_hour,
          price_per_hour_transport: :price_per_hour_transport
        })
      end

      db.select("User_project_link", nil, "orderby" => "id") do |user_project_link_orig|
        puts "Migrating user project link #{user_project_link_orig[:id]}"
        user_project_link = UserProjectLink.find_or_initialize_by(id: user_project_link_orig[:id])
        MigrateHelper.assign(user_project_link_orig, user_project_link, transactioner, {
          user_id: :user_id,
          project_id: :project_id
        })
      end

      db.select("Task", nil, "orderby" => "id") do |task_orig|
        puts "Migrating task #{task_orig[:id]}"
        task = Task.find_or_initialize_by(id: task_orig[:id])
        MigrateHelper.assign(task_orig, task, transactioner, {
          project_id: :project_id,
          user_id: :user_id,
          name: :name,
          descr: :description,
          type: :task_type,
          status: :state,
          priority: :priority,
          date_added: :created_at
        })
      end

      db.select("Task_assigned_user", nil, "orderby" => "id") do |task_user_orig|
        puts "Migrating task-assigned-user #{task_user_orig[:id]}"
        task_user = TaskAssignedUser.find_or_initialize_by(id: task_user_orig[:id])
        MigrateHelper.assign(task_user_orig, task_user, transactioner, {
          task_id: :task_id,
          user_id: :user_id
        })
      end

      db.select("Task_check", nil, "orderby" => "id") do |task_check_orig|
        puts "Migrating task-check #{task_check_orig[:id]}"
        task_check = TaskCheck.find_or_initialize_by(id: task_check_orig[:id])
        MigrateHelper.assign(task_check_orig, task_check, transactioner, {
          task_id: :task_id,
          added_user_id: :user_added_id,
          date_added: :created_at,
          name: :name,
          descr: :description,
          checked: :checked
        })
      end

      db.select("User_task_list_link", nil, "orderby" => "id") do |user_task_list_link_orig|
        puts "Migrating user task list link #{user_task_list_link_orig[:id]}"
        user_task_list_link = UserTaskListLink.find_or_initialize_by(id: user_task_list_link_orig[:id])
        MigrateHelper.assign(user_task_list_link_orig, user_task_list_link, transactioner, {
          user_id: :user_id,
          task_id: :task_id
        })
      end

      db.select("Timelog", nil, "orderby" => "id") do |timelog_orig|
        puts "Migrating timelog #{timelog_orig[:id]}"
        timelog = Timelog.find_or_initialize_by(id: timelog_orig[:id])
        MigrateHelper.assign(timelog_orig, timelog, transactioner, {
          task_id: :task_id,
          user_id: :user_id,
          date: :date,
          time: :time,
          time_transport: :time_transport,
          transport_length: :transport_length,
          comment: :comment,
          invoiced: :invoiced,
          invoiced_date: :invoiced_at,
          invoiced_user_id: :invoiced_by_user_id
        })
      end

      db.select("Comment", nil, "orderby" => "id") do |comment_orig|
        puts "Migrating comment #{comment_orig[:id]}"
        comment = Comment.find_or_initialize_by(id: comment_orig[:id])
        MigrateHelper.assign(comment_orig, comment, transactioner, {
          id_per_obj: :id_per_resource,
          user_id: :user_id,
          comment: :comment,
          date_saved: :created_at,
          object_id: :resource_id,
          object_class: :resource_type
        })
      end
    end
  end
end
