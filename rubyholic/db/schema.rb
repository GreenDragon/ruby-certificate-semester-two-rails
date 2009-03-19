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

ActiveRecord::Schema.define(:version => 20090301090457) do

  create_table "events", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "start_date",  :null => false
    t.datetime "end_date",    :null => false
    t.integer  "group_id",    :null => false
    t.integer  "location_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["group_id"], :name => "fk_events_group_id"
  add_index "events", ["location_id"], :name => "fk_events_location_id"

  create_table "groups", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["name"], :name => "index_groups_on_name", :unique => true

  create_table "locations", :force => true do |t|
    t.string   "name",                                       :null => false
    t.string   "address",                                    :null => false
    t.text     "notes"
    t.decimal  "latitude",   :precision => 15, :scale => 10, :null => false
    t.decimal  "longitude",  :precision => 15, :scale => 10, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["address"], :name => "index_locations_on_address", :unique => true
  add_index "locations", ["latitude", "longitude"], :name => "index_locations_on_latitude_and_longitude", :unique => true
  add_index "locations", ["name"], :name => "index_locations_on_name", :unique => true

end
