class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer 'my_id'
      t.integer 'friend_id'
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
