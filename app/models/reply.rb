class Reply < ActiveRecord::Base
  belongs_to :post
  belongs_to :reply
  validates_presence_of :text
end
