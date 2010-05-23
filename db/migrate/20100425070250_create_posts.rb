class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string "title"
      t.text "text"
      t.integer "position" 
      t.integer "topic_id"
      t.integer "user_id"
      t.string "ip"
      t.integer "viewed_count", :default => 0
      t.integer "replies_count", :default => 0
      t.datetime "replied_at"
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
