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

ActiveRecord::Schema[8.0].define(version: 2025_11_10_122257) do
  create_table "notes", force: :cascade do |t|
    t.integer "schoolwork_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schoolwork_id"], name: "index_notes_on_schoolwork_id"
  end

  create_table "schoolworks", force: :cascade do |t|
    t.integer "subject_id", null: false
    t.integer "schoolwork_type", null: false
    t.string "title", null: false
    t.text "description"
    t.datetime "due_date"
    t.integer "status"
    t.integer "priority"
    t.decimal "grade"
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_schoolworks_on_subject_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "notes", "schoolworks"
  add_foreign_key "schoolworks", "subjects"
end
