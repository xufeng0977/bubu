class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.string :record_type
      t.integer :record_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
