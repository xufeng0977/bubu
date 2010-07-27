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
#      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
    @activities = Activity.paginate :page => params[:page], :conditions => {:user_id => @user.id}, :order => "created_at desc", :per_page => 25
    @can_follow = 'Y'
    if current_user.id == @user.id
      @can_follow = ' '
    else
      contacts = Contact.find_by_sql(['select * from contacts where my_id = ? and friend_id = ?', current_user.id, @user.id])
      if contacts.empty?
        @can_follow = 'Y'
      else
        @can_follow = 'N'
      end
    end
    @followers = @user.followers.find(:all, :limit => '8', :order => 'created_at desc')
    @followees = @user.followees.find(:all, :limit => '8', :order => 'created_at desc')
    @topics = @user.topics.find(:all, :limit => '8', :order => 'created_at desc')
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
  
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
#        flash[:notice] = 'Topic was successfully updated.'
        format.html { redirect_to settings_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  def password
    @user = current_user
  end
  
  def changepassword
    user = User.authenticate(current_user.login, params[:old_password])
    respond_to do |format|
      if user
        @user = current_user
        if @user.update_attributes(params[:user])
          format.html { redirect_to settings_path }    
          format.xml  { head :ok }
        else
          flash[:error] = 'Topic was successfully updated.'
          format.html { redirect_to password_path }
        end
      else
        flash[:error] = 'Topic was  updated.'
        format.html { redirect_to password_path }
      end
    end
  end
  
  def topics
    @user = User.find(params[:id])
    @topics = Topic.paginate :page => params[:page], :conditions => {:user_id => @user.id}, :order => "created_at desc", :per_page => 10
  end
  
  def myhome
    @posts = Post.paginate_by_sql(["select * from posts where topic_id in (select topic_id from subscriptions where user_id = ? ) order by replied_at desc", current_user.id], :page => params[:page], :per_page => 10)
  end
  
  def follow
    user = User.find(params[:id])
    current_user.followees << user
    respond_to do |format|
      format.html { redirect_to url_for (:action => "show", :id => params[:id]) }
      format.xml  { head :ok }
    end
  end
  
  def unfollow
    user = User.find(params[:id])
    current_user.followees.delete(user)
    respond_to do |format|
      format.html { redirect_to url_for (:action => "show", :id => params[:id]) }
      format.xml  { head :ok }
    end
  end
end
