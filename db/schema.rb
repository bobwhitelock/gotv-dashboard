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

ActiveRecord::Schema.define(version: 2019_04_25_222847) do

  create_table "confirmed_labour_voter_observations", force: :cascade do |t|
    t.integer "count", null: false
    t.integer "polling_station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["polling_station_id"], name: "index_clvo_on_polling_station_id"
  end

  create_table "councils", force: :cascade do |t|
    t.string "name"
    t.string "code"
  end

  create_table "polling_stations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "pre_election_registered_voters", null: false
    t.integer "pre_election_labour_promises", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "postcode"
    t.integer "ward_id"
    t.integer "council_id"
    t.index ["council_id"], name: "index_polling_stations_on_council_id"
    t.index ["ward_id"], name: "index_polling_stations_on_ward_id"
  end

  create_table "polling_stations_work_spaces", id: false, force: :cascade do |t|
    t.integer "work_space_id", null: false
    t.integer "polling_station_id", null: false
  end

  create_table "turnout_observations", force: :cascade do |t|
    t.integer "count", null: false
    t.integer "polling_station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "work_space_id"
    t.index ["polling_station_id"], name: "index_turnout_observations_on_polling_station_id"
    t.index ["work_space_id"], name: "index_turnout_observations_on_work_space_id"
  end

  create_table "wards", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.integer "council_id"
    t.index ["council_id"], name: "index_wards_on_council_id"
  end

  create_table "work_spaces", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "identifier", null: false
  end

end
