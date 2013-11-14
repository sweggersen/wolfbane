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

ActiveRecord::Schema.define(version: 20131114121757) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "farmers", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "password_digest"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "backup"
    t.string   "remember_token"
  end

  add_index "farmers", ["email"], name: "index_farmers_on_email", unique: true, using: :btree
  add_index "farmers", ["remember_token"], name: "index_farmers_on_remember_token", using: :btree

  create_table "medicals", force: true do |t|
    t.datetime "datetime"
    t.integer  "weight"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sheep_id"
  end

  add_index "medicals", ["sheep_id"], name: "sheep_id_med_ix", using: :btree

  create_table "positions", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "attacked"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sheep_id"
  end

  add_index "positions", ["sheep_id"], name: "sheep_id_pos_ix", using: :btree

  create_table "sheep", force: true do |t|
    t.integer  "serial"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "farmer_id"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "attacked"
    t.integer  "birthyear"
  end

  add_index "sheep", ["farmer_id"], name: "farmer_id_ix", using: :btree

end
