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

ActiveRecord::Schema.define(version: 20171001000607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "my_fifa_contract_terms", force: :cascade do |t|
    t.integer "contract_id"
    t.date    "end_date"
    t.integer "wage"
    t.integer "signing_bonus"
    t.integer "stat_bonus"
    t.integer "num_stats"
    t.string  "stat_type"
    t.integer "release_clause"
    t.date    "start_date"
  end

  create_table "my_fifa_costs", force: :cascade do |t|
    t.integer "player_id"
    t.integer "fee"
    t.integer "event_id"
    t.text    "notes"
    t.string  "dir",           default: "in"
    t.integer "add_on_clause", default: 0
  end

  create_table "my_fifa_formations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "layout"
    t.string   "pos_1"
    t.string   "pos_2"
    t.string   "pos_3"
    t.string   "pos_4"
    t.string   "pos_5"
    t.string   "pos_6"
    t.string   "pos_7"
    t.string   "pos_8"
    t.string   "pos_9"
    t.string   "pos_10"
    t.string   "pos_11"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "my_fifa_matches", force: :cascade do |t|
    t.integer "team_id"
    t.string  "opponent",                    null: false
    t.string  "competition",                 null: false
    t.integer "score_gf",                    null: false
    t.integer "score_ga",                    null: false
    t.integer "penalties_gf"
    t.integer "penalties_ga"
    t.date    "date_played"
    t.integer "motm_id"
    t.boolean "home",         default: true
    t.integer "squad_id"
  end

  create_table "my_fifa_player_events", force: :cascade do |t|
    t.string  "type"
    t.integer "player_id"
    t.date    "start_date"
    t.date    "end_date"
    t.boolean "loan",        default: false
    t.string  "origin"
    t.string  "destination"
    t.text    "notes"
  end

  create_table "my_fifa_player_records", force: :cascade do |t|
    t.integer "team_id"
    t.integer "match_id"
    t.integer "player_id"
    t.float   "rating"
    t.integer "goals"
    t.integer "assists"
    t.string  "pos",          limit: 10
    t.boolean "cs"
    t.integer "record_id"
    t.integer "yellow_cards",            default: 0
    t.integer "red_cards",               default: 0
    t.string  "injury"
  end

  create_table "my_fifa_player_seasons", force: :cascade do |t|
    t.integer "season_id"
    t.integer "player_id"
    t.integer "kit_no"
    t.integer "value"
    t.integer "ovr"
    t.integer "age",       default: 0
  end

  create_table "my_fifa_players", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name",                        null: false
    t.string   "pos",                         null: false
    t.string   "sec_pos"
    t.boolean  "active",      default: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "start_ovr",   default: 0
    t.string   "nationality"
    t.boolean  "youth",       default: false
    t.text     "notes"
    t.string   "status",      default: ""
    t.integer  "start_value", default: 0
    t.integer  "start_age",   default: 0
  end

  create_table "my_fifa_seasons", force: :cascade do |t|
    t.integer "team_id"
    t.integer "captain_id"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "start_club_worth"
    t.integer "end_club_worth"
    t.integer "transfer_budget"
    t.integer "wage_budget"
    t.text    "competitions"
  end

  create_table "my_fifa_squads", force: :cascade do |t|
    t.integer "team_id"
    t.string  "squad_name",   null: false
    t.integer "player_id_1"
    t.integer "player_id_2"
    t.integer "player_id_3"
    t.integer "player_id_4"
    t.integer "player_id_5"
    t.integer "player_id_6"
    t.integer "player_id_7"
    t.integer "player_id_8"
    t.integer "player_id_9"
    t.integer "player_id_10"
    t.integer "player_id_11"
    t.integer "formation_id"
  end

  create_table "my_fifa_teams", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "team_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.date     "current_date"
    t.text     "teams_played"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "username",               default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "full_name",              default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "team_id"
    t.integer  "formation_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
