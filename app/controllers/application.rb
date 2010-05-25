# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0e0ba58e8436cf892d8bff264354e9bf'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  include AuthenticatedSystem
  
  def create_activity (user_id, record_type, record_id)
    @activity = Activity.new
    @activity.user_id = user_id
    @activity.record_type = record_type
    @activity.record_id = record_id
    @activity.save
  end

end
