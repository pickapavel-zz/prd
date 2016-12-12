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

ActiveRecord::Schema.define(version: 20161212072009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "country"
    t.string   "zip"
    t.string   "ic"
    t.string   "surname"
    t.string   "legal_form"
    t.string   "title"
    t.string   "condition"
    t.string   "core_business"
    t.date     "registration_date"
    t.string   "record_id"
    t.string   "segment"
    t.integer  "user_id"
    t.integer  "hard_ko_criteria"
    t.integer  "soft_ko_criteria"
    t.string   "data_source"
    t.boolean  "consolidated"
    t.date     "last_updated"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "non_customer",      default: false
    t.integer  "segment_type",      default: 0
  end

  create_table "collaborations", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "collaborator_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "corporates", force: :cascade do |t|
    t.boolean  "is_owner"
    t.string   "name"
    t.string   "surname"
    t.string   "identification_no"
    t.string   "permanent_residence"
    t.integer  "client_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "financial_indicators", force: :cascade do |t|
    t.decimal  "ebitda"
    t.decimal  "operating_id"
    t.decimal  "debt_service"
    t.decimal  "operating_dscr"
    t.decimal  "total_dscr"
    t.integer  "year"
    t.integer  "client_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "interface_caches", force: :cascade do |t|
    t.string   "ic"
    t.text     "source"
    t.integer  "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loan_applications", force: :cascade do |t|
    t.decimal  "limit"
    t.integer  "duration"
    t.decimal  "interest"
    t.decimal  "payment"
    t.decimal  "apr"
    t.integer  "client_id"
    t.boolean  "security"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "title"
    t.string   "user_name"
    t.integer  "status",     default: 0
  end

  create_table "partnerships", force: :cascade do |t|
    t.integer  "partner_id"
    t.integer  "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "role",            default: 0
    t.string   "team"
  end

end
