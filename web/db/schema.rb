# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100317153207) do

  create_table "markers", :force => true do |t|
    t.integer  "user_id"
    t.string   "emotion"
    t.string   "test"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trace_points", :force => true do |t|
    t.float    "lat"
    t.float    "lon"
    t.datetime "timestamp"
    t.integer  "trace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "traces", :force => true do |t|
    t.integer  "user_id"
    t.string   "file_name"
    t.boolean  "inserted"
    t.string   "transport"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "auth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
