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

ActiveRecord::Schema.define(:version => 20110106112954) do

  create_table "emotions", :force => true do |t|
    t.string   "text"
    t.string   "icon"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "markers", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
    t.float    "lat"
    t.float    "lon"
    t.integer  "project_id"
    t.integer  "emotion_id"
  end

  add_index "markers", ["lat"], :name => "index_markers_on_lat"
  add_index "markers", ["lon"], :name => "index_markers_on_lon"
  add_index "markers", ["user_id"], :name => "index_markers_on_user_id"

  create_table "modes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "home_location_lat"
    t.float    "home_location_lon"
    t.integer  "home_location_zoom"
    t.integer  "max_markers"
    t.integer  "max_traces"
    t.integer  "max_trace_points_summary"
    t.integer  "max_waypoints_summary"
    t.integer  "gps_not_before"
    t.integer  "gps_not_after"
    t.string   "user_password"
    t.string   "admin_password"
    t.float    "dp_threshold"
    t.string   "location_text"
    t.string   "project_name"
    t.string   "reviewer_password"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "shadow_scans", :force => true do |t|
    t.text     "scan_id"
    t.integer  "school_id"
    t.integer  "mode_id"
    t.integer  "user_id"
    t.text     "alias"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "trace_points", :force => true do |t|
    t.float    "lat"
    t.float    "lon"
    t.datetime "timestamp"
    t.integer  "trace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "segment",    :default => 1
  end

  add_index "trace_points", ["trace_id"], :name => "index_trace_points_on_trace_id"

  create_table "traces", :force => true do |t|
    t.integer  "user_id"
    t.string   "file_name"
    t.boolean  "inserted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mode_id"
    t.float    "min_lat"
    t.float    "max_lat"
    t.float    "min_lon"
    t.float    "max_lon"
    t.integer  "school_id"
    t.text     "alias"
    t.integer  "project_id"
  end

  add_index "traces", ["max_lat"], :name => "index_traces_on_max_lat"
  add_index "traces", ["max_lon"], :name => "index_traces_on_max_lon"
  add_index "traces", ["min_lat"], :name => "index_traces_on_min_lat"
  add_index "traces", ["min_lon"], :name => "index_traces_on_min_lon"
  add_index "traces", ["mode_id"], :name => "index_traces_on_mode_id"
  add_index "traces", ["user_id"], :name => "index_traces_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "auth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "waypoints", :force => true do |t|
    t.float    "lat"
    t.float    "lon"
    t.datetime "timestamp"
    t.integer  "trace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "waypoints", ["trace_id"], :name => "index_waypoints_on_trace_id"

end
