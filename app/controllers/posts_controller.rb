class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
  before_filter :login_required, :except => [:index, :show, :tag]
  
  def index
    @topic = Topic.find(params[:topic_id])
    @user = @topic.user

    @posts = Post.paginate :page => params[:page], :conditions => {:topic_id => params[:topic_id]}, :order => "position", :per_page => 10
    
    @sub_users = @topic.users.find(:all, :limit => 8, :order => 'created_at desc')
    
    subscriptions = Subscription.find_by_sql(['select * from subscriptions where user_id = ? and topic_id = ?', current_user.id, @topic.id])
    @can_follow = 'Y'
    if subscriptions.empty?
      @can_follow = 'Y'
    else
      @can_follow = 'N'
    end
    
    @similiar_topics = Topic.find_tagged_with(@topic.tag_list, :limit => 10)
    @similiar_topics.delete(@topic)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
#    @post = Post.new
    @post = Post.new(:topic_id => params[:topic_id])
    @topic = Topic.find(params[:topic_id])
    @user = current_user
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create

    @post = Post.new(params[:post])
    @post.topic_id = params[:topic_id]
    @post.user_id = current_user.id
    @post.replied_at = Time.now
    @post.ip = get_client_ip request

    respond_to do |format|
      if @post.save
        @post.move_to_top
        topic = @post.topic
        unless Subscription.find (:first, :conditions => {:user_id => current_user.id, :topic_id => topic.id})
          current_user.topics << topic
        end
        topic.posts_count += 1
        topic.save
        create_activity current_user.id, "Post", @post.id
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to topic_post_replies_path(@post.topic_id, @post.id) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
