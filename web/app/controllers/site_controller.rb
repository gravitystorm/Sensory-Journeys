class SiteController < ApplicationController
  def index
    @schools = School.find(:all)
  end
  
  def edit
    if params[:scan]
      # could validate the path here
      @overlay_url = WP_URL + 'files/scans/' + params[:scan] + '/'
    end
    if params[:trace]
      @trace = Trace.find(params[:trace])
      @showtrace = true if @trace
    end
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
