class SiteController < ApplicationController
  
  before_filter :authorize
  before_filter :require_user, :only => [:edit]
  
  def index
    @schools = School.find(:all)
    @modes = Mode.find(:all, :order => :id)
    if params[:mode]
      @mode = Mode.find_by_id(params[:mode])
    end
    @scans = Wpscan.find(:all, :conditions => {:last_step => 6}, :limit => MAX_SCANS)
  end
  
  def edit
    @modes = Mode.find(:all, :order => :id)
    if params[:scan]
      # could validate the path here
      if(!ShadowScan.find_by_scan_id(params[:scan]))
        redirect_to(:controller => :shadow_scan, :action => :claim, :id=> params[:scan]) and return
      end
      # TODO skip this if it's going to be shown otherwise
      @overlay_url = WP_URL + 'files/scans/' + params[:scan] + '/'
    end
    if params[:trace]
      @trace = Trace.find(params[:trace])
      @showtrace = true if @trace
    end
    if params[:mode]
      @mode = Mode.find_by_id(params[:mode])
    end
    #setup url parameters for fetching traces
    #todo needs urlencoding?
    trace_params = []
    if session[:alias]
      trace_params << "alias=#{session[:alias]}"
    end
    if @mode
      trace_params << "mode=#{@mode.id}"
    end
    trace_params << "user=#{@user.id}"
    @trace_url_params = trace_params.join("&")
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
      else
        flash[:error] = "You supplied the wrong password, please try again."
        # TODO keep password dialog open
        redirect_to(:action => :index)
      end
    else
      flash[:error] = "You need to supply a password."
      redirect_to(:action => :index)
    end
  end
  
  def logout
    session[:user] = nil
    flash[:notice] = "You are now logged out"
    redirect_to(:action => :index)
  end
  
  def fetchalias
    if params[:alias] && (params[:alias] != '')
      scans = [] #shadow_scans.fetch blah blah
      traces = Trace.find(:all, :conditions => {:alias => params[:alias]})
      if traces.length == 0 && scans.length == 0
        flash[:error] = "I found no traces or scans with the alias '#{params[:alias]}'"
        session[:alias] = nil
      else
        flash[:notice] = "I found #{traces.length} traces and #{scans.length} scans with the alias '#{params[:alias]}'"
        session[:alias] = params[:alias]
      end
    else
      flash[:error] = "No alias entered"
      session[:alias] = nil
    end
    redirect_to(:action => :edit)
  end
end
