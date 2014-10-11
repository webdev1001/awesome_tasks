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

ActiveRecord::Schema.define(version: 20141011092125) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

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

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "invoice_groups", force: true do |t|
    t.string "name"
  end

  create_table "invoice_lines", force: true do |t|
    t.string   "title"
    t.float    "amount"
    t.integer  "quantity"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_lines", ["invoice_id"], name: "index_invoice_lines_on_invoice_id", using: :btree

  create_table "invoices", force: true do |t|
    t.string   "title"
    t.date     "date"
    t.string   "invoice_no"
    t.string   "invoice_type"
    t.float    "amount"
    t.integer  "organization_id"
    t.integer  "user_id"
    t.date     "payment_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creditor_id"
    t.integer  "invoice_group_id"
    t.boolean  "no_vat"
    t.string   "state"
  end

  add_index "invoices", ["creditor_id"], name: "index_invoices_on_creditor_id", using: :btree
  add_index "invoices", ["invoice_group_id"], name: "index_invoices_on_invoice_group_id", using: :btree
  add_index "invoices", ["invoice_no"], name: "index_invoices_on_invoice_no", using: :btree
  add_index "invoices", ["organization_id"], name: "index_invoices_on_organization_id", using: :btree
  add_index "invoices", ["state"], name: "index_invoices_on_state", using: :btree
  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "vat_no"
    t.text     "payment_info"
    t.string   "delivery_address"
    t.string   "delivery_zip_code"
    t.string   "delivery_city"
    t.string   "delivery_country"
    t.string   "invoice_address"
    t.string   "invoice_zip_code"
    t.string   "invoice_city"
    t.string   "invoice_country"
    t.boolean  "customer"
    t.boolean  "creditor"
  end

  add_index "organizations", ["creditor"], name: "index_organizations_on_creditor", using: :btree
  add_index "organizations", ["customer"], name: "index_organizations_on_customer", using: :btree

  create_table "project_autoassigned_users", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_autoassigned_users", ["project_id"], name: "index_project_autoassigned_users_on_project_id", using: :btree
  add_index "project_autoassigned_users", ["user_id"], name: "index_project_autoassigned_users_on_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.integer  "organization_id"
    t.integer  "user_added_id"
    t.string   "name"
    t.text     "description"
    t.datetime "deadline_at"
    t.float    "price_per_hour"
    t.float    "price_per_hour_transport"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["organization_id"], name: "index_projects_on_organization_id", using: :btree
  add_index "projects", ["user_added_id"], name: "index_projects_on_user_added_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

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
    t.integer  "user_assigned_id"
  end

  add_index "task_checks", ["task_id"], name: "index_task_checks_on_task_id", using: :btree
  add_index "task_checks", ["user_added_id"], name: "index_task_checks_on_user_added_id", using: :btree
  add_index "task_checks", ["user_assigned_id"], name: "index_task_checks_on_user_assigned_id", using: :btree

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

  create_table "uploaded_files", force: true do |t|
    t.string   "title"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "uploaded_files", ["resource_type", "resource_id"], name: "index_uploaded_files_on_resource_type_and_resource_id", using: :btree
  add_index "uploaded_files", ["user_id"], name: "index_uploaded_files_on_user_id", using: :btree

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
