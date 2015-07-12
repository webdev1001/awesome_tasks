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

ActiveRecord::Schema.define(version: 20150617102336) do

  create_table "account_import_columns", force: :cascade do |t|
    t.integer  "account_import_id", limit: 4
    t.integer  "column_no",         limit: 4
    t.string   "column_type",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_import_columns", ["account_import_id"], name: "index_account_import_columns_on_account_import_id", using: :btree

  create_table "account_imports", force: :cascade do |t|
    t.integer  "account_id",    limit: 4
    t.string   "state",         limit: 255
    t.string   "file_encoding", limit: 255
    t.string   "separator",     limit: 255
    t.string   "amount_format", limit: 255
    t.datetime "executed_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_imports", ["account_id"], name: "index_account_imports_on_account_id", using: :btree

  create_table "account_lines", force: :cascade do |t|
    t.integer  "account_id",        limit: 4
    t.integer  "account_import_id", limit: 4
    t.integer  "invoice_id",        limit: 4
    t.string   "text",              limit: 255
    t.datetime "interest_at"
    t.datetime "booked_at"
    t.float    "amount",            limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_lines", ["account_id"], name: "index_account_lines_on_account_id", using: :btree
  add_index "account_lines", ["account_import_id"], name: "index_account_lines_on_account_import_id", using: :btree
  add_index "account_lines", ["amount"], name: "index_account_lines_on_amount", using: :btree
  add_index "account_lines", ["booked_at"], name: "index_account_lines_on_booked_at", using: :btree
  add_index "account_lines", ["interest_at"], name: "index_account_lines_on_interest_at", using: :btree
  add_index "account_lines", ["invoice_id"], name: "index_account_lines_on_invoice_id", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "id_per_resource", limit: 4
    t.string   "resource_type",   limit: 255
    t.integer  "resource_id",     limit: 4
    t.integer  "user_id",         limit: 4
    t.text     "comment",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["resource_type", "resource_id"], name: "index_comments_on_resource_type_and_resource_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "invoice_group_links", force: :cascade do |t|
    t.integer  "invoice_id",       limit: 4
    t.integer  "invoice_group_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_group_links", ["invoice_group_id"], name: "index_invoice_group_links_on_invoice_group_id", using: :btree
  add_index "invoice_group_links", ["invoice_id"], name: "index_invoice_group_links_on_invoice_id", using: :btree

  create_table "invoice_groups", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "invoice_lines", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.decimal  "amount",                 precision: 10, scale: 2
    t.float    "quantity",   limit: 24
    t.integer  "invoice_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timelog_id", limit: 4
  end

  add_index "invoice_lines", ["invoice_id"], name: "index_invoice_lines_on_invoice_id", using: :btree
  add_index "invoice_lines", ["timelog_id"], name: "index_invoice_lines_on_timelog_id", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.date     "date"
    t.string   "invoice_no",      limit: 255
    t.string   "invoice_type",    limit: 255
    t.decimal  "amount",                      precision: 10, scale: 2
    t.integer  "organization_id", limit: 4
    t.integer  "user_id",         limit: 4
    t.date     "payment_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creditor_id",     limit: 4
    t.boolean  "no_vat",          limit: 1
    t.string   "state",           limit: 255
  end

  add_index "invoices", ["creditor_id"], name: "index_invoices_on_creditor_id", using: :btree
  add_index "invoices", ["invoice_no"], name: "index_invoices_on_invoice_no", using: :btree
  add_index "invoices", ["organization_id"], name: "index_invoices_on_organization_id", using: :btree
  add_index "invoices", ["state"], name: "index_invoices_on_state", using: :btree
  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",             limit: 255
    t.string   "vat_no",            limit: 255
    t.text     "payment_info",      limit: 65535
    t.string   "delivery_address",  limit: 255
    t.string   "delivery_zip_code", limit: 255
    t.string   "delivery_city",     limit: 255
    t.string   "delivery_country",  limit: 255
    t.string   "invoice_address",   limit: 255
    t.string   "invoice_zip_code",  limit: 255
    t.string   "invoice_city",      limit: 255
    t.string   "invoice_country",   limit: 255
    t.boolean  "customer",          limit: 1
    t.boolean  "creditor",          limit: 1
  end

  add_index "organizations", ["creditor"], name: "index_organizations_on_creditor", using: :btree
  add_index "organizations", ["customer"], name: "index_organizations_on_customer", using: :btree

  create_table "project_autoassigned_users", force: :cascade do |t|
    t.integer  "project_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_autoassigned_users", ["project_id"], name: "index_project_autoassigned_users_on_project_id", using: :btree
  add_index "project_autoassigned_users", ["user_id"], name: "index_project_autoassigned_users_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "organization_id",          limit: 4
    t.integer  "user_added_id",            limit: 4
    t.string   "name",                     limit: 255
    t.string   "state",                    limit: 255,                            default: "active"
    t.text     "description",              limit: 65535
    t.datetime "deadline_at"
    t.decimal  "price_per_hour",                         precision: 10, scale: 2
    t.decimal  "price_per_hour_transport",               precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["organization_id"], name: "index_projects_on_organization_id", using: :btree
  add_index "projects", ["state"], name: "index_projects_on_state", using: :btree
  add_index "projects", ["user_added_id"], name: "index_projects_on_user_added_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "task_assigned_users", force: :cascade do |t|
    t.integer  "task_id",             limit: 4
    t.integer  "user_id",             limit: 4
    t.integer  "user_assigned_by_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_assigned_users", ["task_id"], name: "index_task_assigned_users_on_task_id", using: :btree
  add_index "task_assigned_users", ["user_assigned_by_id"], name: "index_task_assigned_users_on_user_assigned_by_id", using: :btree
  add_index "task_assigned_users", ["user_id"], name: "index_task_assigned_users_on_user_id", using: :btree

  create_table "task_checks", force: :cascade do |t|
    t.integer  "task_id",          limit: 4
    t.integer  "user_added_id",    limit: 4
    t.string   "name",             limit: 255
    t.text     "description",      limit: 65535
    t.boolean  "checked",          limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_assigned_id", limit: 4
    t.integer  "user_checked_id",  limit: 4
    t.integer  "user_assigner_id", limit: 4
  end

  add_index "task_checks", ["task_id"], name: "index_task_checks_on_task_id", using: :btree
  add_index "task_checks", ["user_added_id"], name: "index_task_checks_on_user_added_id", using: :btree
  add_index "task_checks", ["user_assigned_id"], name: "index_task_checks_on_user_assigned_id", using: :btree
  add_index "task_checks", ["user_assigner_id"], name: "index_task_checks_on_user_assigner_id", using: :btree
  add_index "task_checks", ["user_checked_id"], name: "index_task_checks_on_user_checked_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "project_id",  limit: 4
    t.integer  "user_id",     limit: 4
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.string   "task_type",   limit: 255
    t.string   "state",       limit: 255
    t.integer  "priority",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "timelogs", force: :cascade do |t|
    t.integer  "task_id",             limit: 4
    t.integer  "user_id",             limit: 4
    t.date     "date"
    t.time     "time"
    t.time     "time_transport"
    t.integer  "transport_length",    limit: 4
    t.text     "comment",             limit: 65535
    t.boolean  "invoiced",            limit: 1
    t.datetime "invoiced_at"
    t.integer  "invoiced_by_user_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timelogs", ["invoiced_by_user_id"], name: "index_timelogs_on_invoiced_by_user_id", using: :btree
  add_index "timelogs", ["task_id"], name: "index_timelogs_on_task_id", using: :btree
  add_index "timelogs", ["user_id"], name: "index_timelogs_on_user_id", using: :btree

  create_table "uploaded_files", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "resource_type",     limit: 255
    t.integer  "resource_id",       limit: 4
    t.integer  "user_id",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
  end

  add_index "uploaded_files", ["resource_type", "resource_id"], name: "index_uploaded_files_on_resource_type_and_resource_id", using: :btree
  add_index "uploaded_files", ["user_id"], name: "index_uploaded_files_on_user_id", using: :btree

  create_table "user_project_links", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_project_links", ["project_id"], name: "index_user_project_links_on_project_id", using: :btree
  add_index "user_project_links", ["user_id"], name: "index_user_project_links_on_user_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "role",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "user_task_list_links", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "task_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_task_list_links", ["task_id"], name: "index_user_task_list_links_on_task_id", using: :btree
  add_index "user_task_list_links", ["user_id"], name: "index_user_task_list_links_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "username",               limit: 255
    t.string   "encrypted_password",     limit: 255
    t.string   "email",                  limit: 255
    t.string   "locale",                 limit: 255
    t.boolean  "active",                 limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
