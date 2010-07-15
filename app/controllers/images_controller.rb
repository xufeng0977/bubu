class ImagesController < ApplicationController

  # render new.rhtml
  def new
    @image = Image.new
    @user = current_user
  end
 
  def create
    @image = Image.new(params[:image])
    if @image.save
      current_user.image_id = @image.id
      current_user.save
      flash[:notice] = 'Attachment was successfully created.'
      redirect_to settings_path
    else
      render :action => :new
    end
  end
  
end