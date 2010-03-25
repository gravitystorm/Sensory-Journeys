class SiteController < ApplicationController
  def index
    @schools = School.find(:all)
  end
  
  def edit
  end

  def login
    #TODO do stuff
    flash[:notice] = "Login functionality not yet implemented"
    redirect_to(:action => :edit)
  end
  
  def logout
    #TODO do stuff
    flash[:notice] = "You are now logged out"
    redirect_to(:action => :index)
  end
end
