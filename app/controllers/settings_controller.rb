class SettingsController < ApplicationController

  def create
  end

  def edit
  end

  def update
  end
  
  def index
    @user = current_user
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @activities }
    end
  end

end
