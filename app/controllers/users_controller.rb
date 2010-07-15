class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.name = @user.login
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
    @activities = Activity.paginate :page => params[:page], :conditions => {:user_id => @user.id}, :order => "created_at desc", :per_page => 25
  end
  
  def settings
    @user = current_user
    @image = nil
    if @user.image_id
      @image = Image.find(@user.image_id)
    end
    
    respond_to do |format|
      format.html # settings.html.erb
#      format.xml  { render :xml => @activities }
    end
  end
  
  def image
    @user = current_user
    @image = Image.new
    
    respond_to do |format|
      format.html # image.html.erb
#      format.xml  { render :xml => @activities }
    end
  end
end
