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

ActiveRecord::Schema[7.0].define(version: 2022_07_03_062536) do
  create_table "disqualified_jobs", force: :cascade do |t|
    t.string "handler", null: false
    t.text "arguments", null: false
    t.string "queue", null: false
    t.datetime "run_at", null: false
    t.integer "attempts", default: 0, null: false
    t.datetime "locked_at"
    t.string "locked_by"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
