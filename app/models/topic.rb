class Topic < ActiveRecord::Base
  has_many :posts, :order => "position"
  belongs_to :user
  validates_presence_of :title
end
