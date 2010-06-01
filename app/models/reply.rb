class Reply < ActiveRecord::Base
  belongs_to :post
  belongs_to :reply
  belongs_to :user
  validates_presence_of :text
#  acts_as_paranoid
end
