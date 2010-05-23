class Post < ActiveRecord::Base
  has_many :replies
  belongs_to :topic
  belongs_to :user
  acts_as_list :scope => :topic
  validates_presence_of :title
end
