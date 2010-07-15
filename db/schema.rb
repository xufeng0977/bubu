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

ActiveRecord::Schema.define(:version => 20100714225247) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "record_type"
    t.integer  "record_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data", :limit => 16777215
  end

  create_table "images", :force => true do |t|
    t.integer "parent_id"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.integer "db_file_id"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "position"
    t.integer  "topic_id"
    t.integer  "user_id"
    t.string   "ip"
    t.integer  "viewed_count",  :default => 0
    t.integer  "replies_count", :default => 0
    t.datetime "replied_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "replies", :force => true do |t|
    t.text     "text"
    t.integer  "post_id"
    t.integer  "user_id"
    t.integer  "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "ip"
    t.integer  "viewed_count",    :default => 0
    t.integer  "posts_count",     :default => 0
    t.integer  "replies_count",   :default => 0
    t.integer  "rank",            :default => 0
    t.text     "description"
    t.string   "cached_tag_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "signature"
    t.datetime "deleted_at"
    t.integer  "image_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
