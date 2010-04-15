class SiteController < ApplicationController
  
  before_filter :authorize
  before_filter :require_user, :only => [:edit]
  
  def index
    @schools = School.find(:all)
    if params[:mode]
      #TODO validate
      @mode = params[:mode]
    end
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
  
  def about
    render :layout => false
  end

  def logindialog
    render :layout => false
  end
  
  def login
    # TODO admin mode
    if params[:password]
      if params[:password] == USER_PASSWORD
        user = User.new
        user.save!
        session[:user] = user.id
        flash[:notice] = "You are now logged in"
        redirect_to(:action => :edit)
      end
    else
      flash[:notice] = "You need to supply a password"
      redirect_to(:action => :index)
    end
  end
  
  def logout
    session[:user] = nil
    flash[:notice] = "You are now logged out"
    redirect_to(:action => :index)
  end
end
