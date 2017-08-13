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

ActiveRecord::Schema.define(version: 20170813000029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cmsk_fixtures", force: :cascade do |t|
    t.integer  "season_id",                  null: false
    t.date     "date_played"
    t.integer  "result",         default: 0, null: false
    t.string   "home",                       null: false
    t.string   "away",                       null: false
    t.integer  "goals_home"
    t.integer  "goals_away"
    t.integer  "penalties_home"
    t.integer  "penalties_away"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "team_id"
  end

  add_index "cmsk_fixtures", ["season_id"], name: "index_cmsk_fixtures_on_season_id", using: :btree

  create_table "cmsk_games", force: :cascade do |t|
    t.integer "team_id"
    t.string  "opponent",     null: false
    t.string  "competition",  null: false
    t.integer "score_gf",     null: false
    t.integer "score_ga",     null: false
    t.integer "penalties_gf"
    t.integer "penalties_ga"
    t.date    "date_played"
    t.integer "motm_id"
    t.integer "fixture_id"
  end

  create_table "cmsk_player_records", force: :cascade do |t|
    t.integer "team_id"
    t.integer "game_id"
    t.integer "player_id"
    t.float   "rating"
    t.integer "goals"
    t.integer "assists"
    t.string  "pos",       limit: 10
    t.boolean "cs"
  end

  create_table "cmsk_players", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name",                      null: false
    t.string   "pos",                       null: false
    t.string   "sec_pos"
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "cmsk_seasons", force: :cascade do |t|
    t.text     "opponents"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "team_id"
    t.integer  "status",     default: 0
    t.string   "title"
    t.string   "league"
  end

  create_table "cmsk_squads", force: :cascade do |t|
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
  end

  create_table "cmsk_teams", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "team_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "competitions"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
