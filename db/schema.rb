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

ActiveRecord::Schema.define(version: 20141205194551) do

  create_table "connections", force: true do |t|
    t.integer  "mentee_id"
    t.integer  "mentor_id"
    t.text     "introduction"
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "connections", ["mentee_id", "mentor_id"], name: "index_connections_on_mentee_id_and_mentor_id", unique: true
  add_index "connections", ["mentee_id"], name: "index_connections_on_mentee_id"
  add_index "connections", ["mentor_id"], name: "index_connections_on_mentor_id"

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

  create_table "qualifications", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qualifications_users", id: false, force: true do |t|
    t.integer "user_id",          null: false
    t.integer "qualification_id", null: false
  end

  add_index "qualifications_users", ["qualification_id", "user_id"], name: "index_qualifications_users_on_qualification_id_and_user_id"
  add_index "qualifications_users", ["user_id", "qualification_id"], name: "index_qualifications_users_on_user_id_and_qualification_id"

  create_table "skills", force: true do |t|
    t.string  "skill"
    t.integer "user_id"
  end

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
    t.boolean  "merl_member"
    t.string   "slug"
    t.boolean  "signup_complete",        default: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "headline"
    t.string   "industry"
    t.string   "linkedin_profile_url"
    t.string   "linkedin_image_url"
    t.text     "tokens"
    t.string   "nickname"
    t.string   "image"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["slug"], name: "index_users_on_slug"
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true

end
