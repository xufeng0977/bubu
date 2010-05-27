class RepliesController < ApplicationController
  # GET /replies
  # GET /replies.xml
  before_filter :login_required, :except => [:index, :show]
  
  def index
    @post = Post.find(params[:post_id])
    @post.viewed_count += 1
    @post.save
    @topic = Topic.find(params[:topic_id])
#    @replies = Reply.find(:all, :conditions => {:post_id => params[:post_id]})
    @replies = Reply.paginate :page => params[:page], :conditions => {:post_id => params[:post_id]}, :per_page => 5 
    @user = @post.user
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @replies }
    end
  end

  # GET /replies/1
  # GET /replies/1.xml
  def show
    @post = Post.find(params[:post_id])
    @topic = Topic.find(params[:topic_id])
    @reply = Reply.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reply }
    end
  end

  # GET /replies/new
  # GET /replies/new.xml
  def new
    @reply = Reply.new
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:post_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reply }
    end
  end

  # GET /replies/1/edit
  def edit
    @reply = Reply.find(params[:id])
  end

  # POST /replies
  # POST /replies.xml
  def create
    @reply = Reply.new(params[:reply])
    post_id = params[:post_id]
    @reply.post_id = post_id
    @reply.user_id = current_user.id

    respond_to do |format|
      if @reply.save
        topic_id = params[:topic_id]
        @post = Post.find(params[:post_id])
        @post.replies_count += 1
        @post.replied_at = @reply.created_at
        @post.save
        @post.move_to_top
        create_activity current_user.id, "Reply", @reply.id
        flash[:notice] = 'Reply was successfully created.'
        format.html { redirect_to topic_post_replies_path(topic_id, post_id) }
        format.xml  { render :xml => @reply, :status => :created, :location => @reply }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reply.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /replies/1
  # PUT /replies/1.xml
  def update
    @reply = Reply.find(params[:id])

    respond_to do |format|
      if @reply.update_attributes(params[:reply])
        flash[:notice] = 'Reply was successfully updated.'
        format.html { redirect_to(@reply) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reply.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /replies/1
  # DELETE /replies/1.xml
  def destroy
    @reply = Reply.find(params[:id])
    @reply.destroy

    respond_to do |format|
      format.html { redirect_to(replies_url) }
      format.xml  { head :ok }
    end
  end
end
