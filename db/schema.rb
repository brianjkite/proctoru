# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_09_161953) do

  create_table "api_requests", force: :cascade do |t|
    t.string "type", null: false
    t.integer "users_id"
    t.json "params"
    t.json "errors"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["users_id"], name: "index_api_requests_on_users_id"
  end

  create_table "audits", force: :cascade do |t|
    t.string "model"
    t.json "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "colleges", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exam_windows", force: :cascade do |t|
    t.integer "exam_id"
    t.date "start_time_window", null: false
    t.date "end_time_window", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exam_id"], name: "index_exam_windows_on_exam_id"
  end

  create_table "exams", force: :cascade do |t|
    t.string "title", null: false
    t.json "questions"
    t.integer "college_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "\"exam_window\"", name: "index_exams_on_exam_window"
    t.index ["college_id"], name: "index_exams_on_college_id"
  end

  create_table "exams_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "exam_id"
    t.index ["exam_id"], name: "index_exams_users_on_exam_id"
    t.index ["user_id"], name: "index_exams_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone_number", limit: 10, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
