class TopicsController < ApplicationController
  # GET /topics
  # GET /topics.xml
  before_filter :login_required, :except => [:index, :show, :search]
#  protect_from_forgery :except => :search

  def index
#    @topics = Topic.find(:all)
    @new_topics = Topic.find(:all, :order => 'created_at desc', :limit => 10)
    @tags = Topic.tag_counts
    @active_posts = Post.find(:all, :order => 'replied_at desc', :limit => 10)
    @hottest_topics = Topic.find(:all, :order => 'posts_count desc', :limit => 20)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new

    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  # POST /topics.xml
  def create
    unless simple_captcha_valid?
      flash[:error] = "invalid captcha code"
      redirect_to :action => "new" 
      return
    end
    @topic = Topic.new(params[:topic])
    @topic.user_id = current_user.id
    @topic.ip = get_client_ip request

    respond_to do |format|
      if @topic.save
        create_activity current_user.id, "Topic", @topic.id
        flash[:notice] = 'Topic was successfully created.'
        format.html { redirect_to topic_posts_path(@topic.id) }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        flash[:notice] = 'Topic was successfully updated.'
        format.html { redirect_to(@topic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end
  
  def tag
    @topics = Topic.find_tagged_with(params[:id])
    
    respond_to do |format|
      format.html # tag.html.erb
      format.xml  { render :xml => @topics }
    end
  end
  
  def search
    text = params[:search_text]
    @topics = Topic.find(:all, :conditions => ['title LIKE ?', '%' + text + '%'])
    
    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @topics }
    end
  end
  
  def popular
    @topics = Topic.paginate :page => params[:page], :order => "posts_count desc", :per_page => 10
    
    respond_to do |format|
      format.html # popular.html.erb
      format.xml  { render :xml => @topics }
    end
  end
  
  def follow
    topic = Topic.find(params[:id])
    current_user.topics << topic
    respond_to do |format|
      format.html { redirect_to topic_posts_path(topic.id) }
      format.xml  { head :ok }
    end
  end
  
  def unfollow
    topic = Topic.find(params[:id])
    current_user.topics.delete(topic)
    respond_to do |format|
      format.html { redirect_to topic_posts_path(topic.id) }
      format.xml  { head :ok }
    end
  end
end
