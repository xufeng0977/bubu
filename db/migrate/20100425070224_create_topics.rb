class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.string "title"
      t.integer "user_id"
      t.string "ip"
      t.integer "viewed_count", :default => 0
      t.integer "posts_count", :default => 0
      t.integer "replies_count", :default => 0
      t.string "cached_tag_list"
      t.timestamps
      t.datetime "deleted_at"
    end
  end

  def self.down
    drop_table :topics
  end
end
