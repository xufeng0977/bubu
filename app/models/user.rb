require 'digest/sha1'

class User < ActiveRecord::Base
#  file_column :image, :magick => {:geometry => "100x100>", :versions => {"thumb" => "50x50", "medium" => "80x80"}}

  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  has_many :posts
  has_many :replies
#  has_many :topics
  has_many :activities
  belongs_to :image
  
  has_many :subscriptions
  has_many :topics, :through => :subscriptions
  
  has_many :followed_users, :class_name => 'Contact', :foreign_key => 'friend_id'
  has_many :following_users, :class_name => 'Contact', :foreign_key => 'my_id'
  
  has_many :followees, :through => :following_users
  
  has_many :followers, :through => :followed_users

  acts_as_paranoid

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :signature



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  protected
    


end
