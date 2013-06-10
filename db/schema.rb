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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130409143127) do

  create_table "accounts", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "vat_type"
    t.decimal  "vat_percent",    :precision => 10, :scale => 0
    t.string   "account_number"
    t.integer  "fiscal_year_id"
  end

  add_index "accounts", ["fiscal_year_id"], :name => "accounts_fiscal_year_id_fk"
  add_index "accounts", ["parent_id", "account_number"], :name => "index_accounts_on_parent_id_and_account_number"

  create_table "event_lines", :force => true do |t|
    t.integer "event_id"
    t.integer "account_id"
    t.decimal "amount",     :precision => 10, :scale => 0
  end

  add_index "event_lines", ["account_id"], :name => "event_lines_account_id_fk"
  add_index "event_lines", ["event_id"], :name => "event_lines_event_id_fk"

  create_table "events", :force => true do |t|
    t.integer  "fiscal_year_id"
    t.integer  "receipt_number"
    t.date     "event_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_date"], :name => "index_events_on_event_date"
  add_index "events", ["fiscal_year_id"], :name => "events_fiscal_year_id_fk"
  add_index "events", ["receipt_number"], :name => "index_events_on_receipt_number"

  create_table "fiscal_years", :force => true do |t|
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fiscal_years", ["start_date"], :name => "index_fiscal_years_on_start_date"

  create_table "preliminary_events", :force => true do |t|
    t.integer  "account_id",                     :null => false
    t.integer  "fiscal_year_id",                 :null => false
    t.integer  "amount_cents",    :default => 0, :null => false
    t.date     "booking_date",                   :null => false
    t.date     "value_date"
    t.date     "payment_date"
    t.string   "counterpart"
    t.string   "account_number"
    t.string   "bic"
    t.text     "description"
    t.string   "reference"
    t.string   "payer_reference"
    t.text     "message"
    t.string   "card_number"
    t.text     "receipt"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "event_id"
  end

  add_index "preliminary_events", ["account_id", "booking_date"], :name => "index_preliminary_events_on_account_id_and_booking_date"
  add_index "preliminary_events", ["event_id"], :name => "index_preliminary_events_on_event_id"
  add_index "preliminary_events", ["fiscal_year_id", "booking_date"], :name => "index_preliminary_events_on_fiscal_year_id_and_booking_date"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  add_foreign_key "accounts", "fiscal_years", :name => "accounts_fiscal_year_id_fk"

  add_foreign_key "event_lines", "accounts", :name => "event_lines_account_id_fk"
  add_foreign_key "event_lines", "events", :name => "event_lines_event_id_fk"

  add_foreign_key "events", "fiscal_years", :name => "events_fiscal_year_id_fk"

end
