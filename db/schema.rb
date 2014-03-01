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

ActiveRecord::Schema.define(version: 20140228183430) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descriptive_questions", force: true do |t|
    t.integer  "exam_id"
    t.string   "description"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exams", force: true do |t|
    t.string   "subject"
    t.integer  "semister"
    t.string   "exam_name"
    t.integer  "course_id"
    t.float    "duration"
    t.integer  "no_of_questions"
    t.float    "negative_mark"
    t.float    "pass_criteria_1"
    t.text     "pass_text_1"
    t.float    "pass_criteria_2"
    t.string   "pass_text_2"
    t.float    "pass_criteria_3"
    t.string   "pass_text_3"
    t.float    "pass_criteria_4"
    t.string   "pass_text_4"
    t.integer  "multiple_choice"
    t.integer  "fill_in_blanks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "faculty_id"
  end

  create_table "faculties", force: true do |t|
    t.string   "name"
    t.string   "designation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faculty_courses", force: true do |t|
    t.integer  "course_id"
    t.integer  "faculty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "multiple_choice_questions", force: true do |t|
    t.integer  "exam_id"
    t.string   "description"
    t.string   "option_1"
    t.string   "option_2"
    t.string   "option_3"
    t.string   "option_4"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", force: true do |t|
    t.integer  "schedule_id"
    t.integer  "total_marks"
    t.float    "marks_secured"
    t.string   "exam_result"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "role"
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", force: true do |t|
    t.integer  "exam_id"
    t.datetime "exam_date_time"
    t.datetime "exam_end_date_time"
    t.date     "schedule_date"
    t.string   "access_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.string   "name"
    t.date     "dob"
    t.date     "joining_date"
    t.integer  "course_id"
    t.integer  "semister"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roll_number"
  end

  create_table "users", force: true do |t|
    t.string   "user_id",                default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.integer  "role_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.integer  "resource_id"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_id"], name: "index_users_on_user_id", unique: true, using: :btree

end
