class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.text "text"
      t.integer "post_id"
      t.integer "user_id"
      t.integer "ip"
      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end
