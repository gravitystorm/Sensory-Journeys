class SiteController < ApplicationController
  
  before_filter :authorize
  before_filter :require_user, :only => [:edit]
  
  def index
    @schools = @current_project.schools.find(:all)
    @modes = @current_project.modes.find(:all)
    @emotions = @current_project.emotions.find(:all)
    if params[:mode]
      @mode = @current_project.modes.find_by_id(params[:mode])
    end
  end
  
  def edit
    @modes = @current_project.modes.find(:all)
    @emotions = @current_project.emotions.find(:all)
    if params[:scan]
      # could validate the path here
      if(!@current_project.shadow_scans.find_by_scan_id(params[:scan]))
        redirect_to(:controller => :shadow_scan, :action => :claim, :id=> params[:scan]) and return
      end
      # TODO skip this if it's going to be shown otherwise
      @overlay_url = WP_URL + 'files/scans/' + params[:scan] + '/${z}/${x}/${y}.png'
      @wpscan = Wpscan.find_by_id(params[:scan])
      @wpprint = Wpprint.find_by_id(@wpscan.print_id) if @wpscan
    end
    if params[:trace]
      @trace = @current_project.traces.find(params[:trace])
      @showtrace = true if @trace
    end
    if params[:mode]
      @mode = @current_project.modes.find_by_id(params[:mode])
    end
    #setup url parameters for fetching traces
    #todo needs urlencoding?
    trace_params = []
    if session[:alias]
      trace_params << "alias=#{session[:alias]}"
      @alias_traces_count = @current_project.traces.find(:all, :conditions => {:alias => session[:alias]}).length
    end
    if @mode
      trace_params << "mode=#{@mode.id}"
    end
    trace_params << "user=#{@user.id}"
    @trace_url_params = trace_params.join("&")
    @scans = @user.shadow_scans # TODO needs limiting?
    if session[:alias]
      @alias_scans = @current_project.shadow_scans.find(:all, :conditions => {:alias => session[:alias]})
      @alias_scans_count = @alias_scans.length
    end
  end
  
  def about
    render :layout => false
  end

  def logindialog
    render :layout => false
  end

  def splash
    render :layout => 'plain'
  end
  
  def login
    if params[:password]
      if params[:password] == @current_project.user_password
        user = User.new
        user.save!
        session[:user] = user.id
        session[:alias] = nil
        flash[:notice] = "You are now logged in"
        redirect_to(:action => :edit)
      elsif params[:password] == @current_project.reviewer_password
        user = User.new
        user.save!
        session[:user] = user.id
        session[:reviewer] = true
        session[:admin] = false
        flash[:notice] = "Welcome, reviewer"
        redirect_to(:controller => :admin, :action => :index)
      elsif params[:password] == @current_project.admin_password
        user = User.new
        user.save!
        session[:user] = user.id
        session[:admin] = true
        flash[:notice] = "Welcome, administrator"
        redirect_to(:controller => :admin, :action => :index)
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
      scans = @current_project.shadow_scans.find(:all, :conditions => {:alias => params[:alias]})
      traces = @current_project.traces.find(:all, :conditions => {:alias => params[:alias]})
      if traces.length == 0 && scans.length == 0
        flash[:error] = "I found no traces or scans with the alias '#{params[:alias]}'"
        session[:alias] = nil
      else
        flash[:notice] = "Welcome, #{params[:alias]}!"
        session[:alias] = params[:alias]
      end
    else
      flash[:error] = "No alias entered"
      session[:alias] = nil
    end
    redirect_to(:action => :edit)
  end
end
