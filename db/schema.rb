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

ActiveRecord::Schema.define(version: 20150505000829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.string   "name"
    t.boolean  "sended",       default: false
    t.date     "sending_date"
    t.integer  "schedule_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "assignments", ["schedule_id"], name: "index_assignments_on_schedule_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.integer  "book_type"
    t.string   "name"
    t.integer  "parts_number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "books_schedules", force: :cascade do |t|
    t.integer "book_id"
    t.integer "schedule_id"
  end

  add_index "books_schedules", ["book_id"], name: "index_books_schedules_on_book_id", using: :btree
  add_index "books_schedules", ["schedule_id"], name: "index_books_schedules_on_schedule_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.integer  "step"
    t.string   "name"
    t.date     "start_date"
    t.boolean  "active",     default: false
    t.integer  "duration"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                         null: false
    t.string   "phone"
    t.string   "crypted_password",              null: false
    t.string   "password_salt",                 null: false
    t.string   "persistence_token",             null: false
    t.integer  "login_count",       default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.integer  "notification_type", default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["last_request_at"], name: "index_users_on_last_request_at", using: :btree
  add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", using: :btree

end