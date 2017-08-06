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

ActiveRecord::Schema.define(version: 20170629044239) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "provider",                             default: "email", null: false
    t.string   "uid",                                  default: "",      null: false
    t.string   "encrypted_password",                   default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.text     "tokens",                 limit: 65535
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "role"
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true, using: :btree
  end

  create_table "batch_processes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "project_id"
    t.string   "name"
    t.integer  "batch_process_type"
    t.text     "operation",          limit: 4294967295
    t.integer  "repeat_time"
    t.boolean  "enable",                                default: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.datetime "executed_at"
    t.index ["project_id"], name: "index_batch_processes_on_project_id", using: :btree
  end

  create_table "cells", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "value"
    t.integer  "column_id"
    t.integer  "row_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["column_id"], name: "index_cells_on_column_id", using: :btree
    t.index ["row_id"], name: "index_cells_on_row_id", using: :btree
  end

  create_table "clients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "columns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "content_type", default: 0
    t.string   "condition"
    t.integer  "table_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "required",     default: true
    t.index ["table_id"], name: "index_columns_on_table_id", using: :btree
  end

  create_table "crono_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "job_id",                               null: false
    t.text     "log",               limit: 4294967295
    t.datetime "last_performed_at"
    t.boolean  "healthy"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true, using: :btree
  end

  create_table "csv_exports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "data_location"
    t.string   "stage"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "db_connects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "host"
    t.string   "adapter"
    t.string   "username"
    t.string   "password"
    t.string   "database"
    t.integer  "port"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_db_connects_on_project_id", using: :btree
  end

  create_table "item_masters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.binary   "layout",     limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "item_type"
  end

  create_table "local_variables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "page_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "value",         limit: 65535
    t.integer  "variable_type"
    t.index ["page_id"], name: "index_local_variables_on_page_id", using: :btree
  end

  create_table "log_changements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "page_id"
    t.integer  "column_id"
    t.string   "column_name"
    t.string   "bf_item"
    t.string   "af_item"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "project_name"
    t.string   "page_name"
  end

  create_table "operations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "stage"
    t.string   "name"
    t.text     "query",           limit: 65535
    t.string   "condition"
    t.integer  "page_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "ds_name"
    t.integer  "is_array",                      default: 0
    t.string   "per_page"
    t.integer  "background_mode"
    t.index ["page_id"], name: "index_operations_on_page_id", using: :btree
  end

  create_table "pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "sluck"
    t.binary   "layout",     limit: 16777215
    t.integer  "project_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["project_id"], name: "index_pages_on_project_id", using: :btree
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_pictures_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "name",              limit: 65535
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "short_name"
    t.integer  "patitent_num"
    t.date     "period_start_date"
    t.date     "period_end_date"
    t.integer  "client_id"
    t.string   "slug"
    t.index ["client_id"], name: "index_projects_on_client_id", using: :btree
    t.index ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
  end

  create_table "raws", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "table_id"
    t.integer  "row_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "data",       limit: 65535
    t.index ["row_id"], name: "index_raws_on_row_id", using: :btree
    t.index ["table_id"], name: "index_raws_on_table_id", using: :btree
  end

  create_table "role_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_role_types_on_project_id", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "role_type_id"
    t.index ["role_type_id"], name: "index_roles_on_role_type_id", using: :btree
    t.index ["user_id", "name"], name: "index_roles_on_user_id_and_project_id_and_name", unique: true, using: :btree
    t.index ["user_id"], name: "index_roles_on_user_id", using: :btree
  end

  create_table "rows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "unique_id"
    t.integer  "table_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_rows_on_table_id", using: :btree
  end

  create_table "session_variables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "value"
    t.integer  "variable_type"
    t.index ["project_id"], name: "index_session_variables_on_project_id", using: :btree
  end

  create_table "tables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id"
    t.index ["project_id"], name: "index_tables_on_project_id", using: :btree
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.integer  "project_id"
    t.date     "deadline"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["project_id"], name: "index_tasks_on_project_id", using: :btree
  end

  create_table "user_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "provider",                             default: "email", null: false
    t.string   "uid",                                  default: "",      null: false
    t.string   "encrypted_password",                   default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.text     "tokens",                 limit: 65535
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  add_foreign_key "batch_processes", "projects"
  add_foreign_key "cells", "columns"
  add_foreign_key "cells", "rows"
  add_foreign_key "columns", "tables"
  add_foreign_key "db_connects", "projects"
  add_foreign_key "local_variables", "pages"
  add_foreign_key "operations", "pages"
  add_foreign_key "pages", "projects"
  add_foreign_key "pictures", "projects"
  add_foreign_key "projects", "clients"
  add_foreign_key "raws", "rows"
  add_foreign_key "raws", "tables"
  add_foreign_key "role_types", "projects"
  add_foreign_key "roles", "users"
  add_foreign_key "rows", "tables"
  add_foreign_key "session_variables", "projects"
  add_foreign_key "tables", "projects"
  add_foreign_key "tasks", "projects"
end
