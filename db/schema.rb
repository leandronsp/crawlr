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

ActiveRecord::Schema.define(version: 20160701215130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.string   "url"
    t.integer  "page_id"
    t.integer  "domain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_assets_on_domain_id", using: :btree
    t.index ["page_id"], name: "index_assets_on_page_id", using: :btree
  end

  create_table "domains", force: :cascade do |t|
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.boolean  "visited",    default: false
    t.integer  "domain_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["domain_id"], name: "index_pages_on_domain_id", using: :btree
    t.index ["url", "domain_id"], name: "index_pages_on_url_and_domain_id", unique: true, using: :btree
  end

  add_foreign_key "assets", "domains"
  add_foreign_key "assets", "pages"
  add_foreign_key "pages", "domains"
end
