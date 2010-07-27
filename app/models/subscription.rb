class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
#  acts_as_paranoid
  
end
