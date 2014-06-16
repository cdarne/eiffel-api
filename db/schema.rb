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

ActiveRecord::Schema.define(version: 20140616002628) do

  create_table "questions", force: true do |t|
    t.integer  "order"
    t.text     "description"
    t.integer  "weight",                default: 1
    t.integer  "survey_id"
    t.integer  "dependent_question_id"
    t.string   "question_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["dependent_question_id"], name: "index_questions_on_dependent_question_id"
  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id"

  create_table "rating_value_entries", force: true do |t|
    t.integer  "rating_value_id"
    t.integer  "order"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_value_entries", ["rating_value_id"], name: "index_rating_value_entries_on_rating_value_id"

  create_table "rating_values", force: true do |t|
    t.integer  "question_id"
    t.integer  "min"
    t.integer  "max"
    t.integer  "step"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_values", ["question_id"], name: "index_rating_values_on_question_id"

  create_table "ratio_value_entries", force: true do |t|
    t.integer  "ratio_value_id"
    t.integer  "order"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratio_value_entries", ["ratio_value_id"], name: "index_ratio_value_entries_on_ratio_value_id"

  create_table "ratio_values", force: true do |t|
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratio_values", ["question_id"], name: "index_ratio_values_on_question_id"

  create_table "select_value_entries", force: true do |t|
    t.integer  "select_value_id"
    t.integer  "order"
    t.integer  "score"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "select_value_entries", ["select_value_id"], name: "index_select_value_entries_on_select_value_id"

  create_table "select_values", force: true do |t|
    t.integer  "question_id"
    t.boolean  "multiple",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "select_values", ["question_id"], name: "index_select_values_on_question_id"

  create_table "surveys", force: true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
