# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140517162525) do

  create_table "comments", force: true do |t|
    t.integer  "id_per_resource"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["resource_type", "resource_id"], name: "index_comments_on_resource_type_and_resource_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "customers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.integer  "customer_id"
    t.integer  "user_added_id"
    t.string   "name"
    t.text     "description"
    t.datetime "deadline_at"
    t.float    "price_per_hour"
    t.float    "price_per_hour_transport"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["customer_id"], name: "index_projects_on_customer_id", using: :btree
  add_index "projects", ["user_added_id"], name: "index_projects_on_user_added_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "task_assigned_users", force: true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.integer  "user_assigned_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_assigned_users", ["task_id"], name: "index_task_assigned_users_on_task_id", using: :btree
  add_index "task_assigned_users", ["user_assigned_by_id"], name: "index_task_assigned_users_on_user_assigned_by_id", using: :btree
  add_index "task_assigned_users", ["user_id"], name: "index_task_assigned_users_on_user_id", using: :btree

  create_table "task_checks", force: true do |t|
    t.integer  "task_id"
    t.integer  "user_added_id"
    t.string   "name"
    t.text     "description"
    t.boolean  "checked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_checks", ["task_id"], name: "index_task_checks_on_task_id", using: :btree
  add_index "task_checks", ["user_added_id"], name: "index_task_checks_on_user_added_id", using: :btree

  create_table "tasks", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "task_type"
    t.string   "state"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "timelogs", force: true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.date     "date"
    t.time     "time"
    t.time     "time_transport"
    t.integer  "transport_length"
    t.text     "comment"
    t.boolean  "invoiced"
    t.datetime "invoiced_at"
    t.integer  "invoiced_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timelogs", ["invoiced_by_user_id"], name: "index_timelogs_on_invoiced_by_user_id", using: :btree
  add_index "timelogs", ["task_id"], name: "index_timelogs_on_task_id", using: :btree
  add_index "timelogs", ["user_id"], name: "index_timelogs_on_user_id", using: :btree

  create_table "user_project_links", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_project_links", ["project_id"], name: "index_user_project_links_on_project_id", using: :btree
  add_index "user_project_links", ["user_id"], name: "index_user_project_links_on_user_id", using: :btree

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "user_task_list_links", force: true do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_task_list_links", ["task_id"], name: "index_user_task_list_links_on_task_id", using: :btree
  add_index "user_task_list_links", ["user_id"], name: "index_user_task_list_links_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "encrypted_password"
    t.string   "email"
    t.string   "locale"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
