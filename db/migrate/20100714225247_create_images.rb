class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column :parent_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :db_file_id, :integer
#      t.integer "user_id"
    end
    create_table :db_files do |t|
      t.binary :data,:limit=>3.megabytes
    end
    
  end

  def self.down
    drop_table :db_files
    drop_table :images
  end
end
