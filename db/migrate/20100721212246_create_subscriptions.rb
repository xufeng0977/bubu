class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer "user_id"
      t.integer "topic_id"
      t.timestamps
      t.datetime "deleted_at"
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
