class Topic < ActiveRecord::Base
  has_many :posts, :order => "position"
  belongs_to :user
  validates_presence_of :title
  
  has_many :subscriptions
  has_many :users, :through => :subscriptions
  
  acts_as_taggable 
  acts_as_paranoid
end
