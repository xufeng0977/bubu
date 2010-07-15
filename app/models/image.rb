class Image < ActiveRecord::Base
  has_attachment :content_type=>:image,
             :storage=>:file_system,
             :min_size =>0,
             :max_size =>2.megabytes,
             :resize_to => '100x100.',
             :thumbnails =>{:thumb=>'50x50>',:medium=>"80x80>"}

  validates_as_attachment
  has_one :user
end
