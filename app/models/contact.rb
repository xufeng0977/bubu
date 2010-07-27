class Contact < ActiveRecord::Base
  belongs_to :followee, :class_name => 'User', :foreign_key => 'friend_id'
  belongs_to :follower, :class_name => 'User', :foreign_key => 'my_id'
end
