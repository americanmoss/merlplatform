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

ActiveRecord::Schema.define(version: 20150324205047) do

  create_table "achievements", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commitments", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "educations", force: true do |t|
    t.string   "school_name"
    t.string   "degree"
    t.string   "field_of_study"
    t.integer  "linkedin_education_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "industries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.string   "industry"
    t.string   "title"
    t.text     "summary"
    t.boolean  "is_current"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_logo_url"
    t.integer  "linkedin_position_id"
    t.integer  "user_id"
    t.string   "company_url"
    t.string   "company_square_logo_url"
  end

  create_table "skills", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "skill_id"
  end

  add_index "skills_users", ["skill_id"], name: "index_skills_users_on_skill_id"
  add_index "skills_users", ["user_id"], name: "index_skills_users_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "linkedin_token"
    t.string   "slug"
    t.boolean  "signup_complete",        default: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "headline"
    t.string   "linkedin_industry"
    t.string   "linkedin_profile_url"
    t.string   "linkedin_image_url"
    t.integer  "user_type",              default: 0
    t.integer  "user_status",            default: 0
    t.integer  "industry_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["slug"], name: "index_users_on_slug"

  create_table "users_and_commitments", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "commitment_id"
  end

  add_index "users_and_commitments", ["commitment_id"], name: "index_users_and_commitments_on_commitment_id"
  add_index "users_and_commitments", ["user_id"], name: "index_users_and_commitments_on_user_id"

end
