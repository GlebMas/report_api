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

ActiveRecord::Schema.define(version: 20151102203211) do

  create_table "campaigns", force: :cascade do |t|
    t.string  "name",                limit: 255
    t.date    "start_date"
    t.date    "end_date"
    t.float   "media_budget",        limit: 24
    t.integer "campaign_manager_id", limit: 4
  end

  create_table "comments", force: :cascade do |t|
    t.text     "text",       limit: 65535
    t.integer  "report_id",  limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "comments", ["report_id"], name: "index_comments_on_report_id", using: :btree

  create_table "creatives", force: :cascade do |t|
    t.string  "name",            limit: 255
    t.integer "creative_number", limit: 4
    t.integer "campaign_id",     limit: 4
  end

  add_index "creatives", ["campaign_id"], name: "index_creatives_on_campaign_id", using: :btree
  add_index "creatives", ["creative_number"], name: "index_creatives_on_creative_number", using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "impressions", limit: 4
    t.integer  "conversions", limit: 4
    t.float    "ctr",         limit: 24
    t.decimal  "spent",                  precision: 10
    t.integer  "clicks",      limit: 4
    t.integer  "campaign_id", limit: 4
    t.integer  "creative_id", limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.date     "date"
  end

  add_index "reports", ["campaign_id"], name: "index_reports_on_campaign_id", using: :btree
  add_index "reports", ["creative_id"], name: "index_reports_on_creative_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "username",               limit: 255
    t.string   "token",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "token_created"
    t.string   "api_key",                limit: 255
  end

  add_index "users", ["api_key"], name: "index_users_on_api_key", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "comments", "reports"
  add_foreign_key "creatives", "campaigns"
  add_foreign_key "reports", "campaigns"
end
