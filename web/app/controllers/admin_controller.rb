class AdminController < ApplicationController
  
  before_filter :authorize
  before_filter :require_reviewer, :except => [:marker_delete, :trace_delete, :scan_remove, :settings]
  before_filter :require_admin, :only => [:marker_delete, :trace_delete, :scan_remove, :settings]
  
  def index
    @markers = @current_project.markers.find(:all)
    @scans = @current_project.shadow_scans.find(:all)
    @traces = @current_project.traces.find(:all)
    @schools = @current_project.schools.find(:all)
    @modes = @current_project.modes.find(:all)
    @emotions = @current_project.emotions.find(:all)
  end
  
  def markers
    @markers = @current_project.markers.find(:all, :order => "id DESC")
    @emotions = @current_project.emotions.find(:all)
  end
  
  def marker_delete
    assert_method :post
    
    marker = @current_project.markers.find(params[:marker_id])
    marker.delete
    flash[:notice] = "Deleted marker #{marker.id}"
    redirect_to :action => :markers
  end
  
  def traces
    @traces = @current_project.traces.find(:all, :order => "id DESC")
    @schools = @current_project.schools.find(:all, :order => "id DESC")
    @modes = @current_project.modes.find(:all, :order => "id DESC")
  end
  
  def trace_delete
    assert_method :post
    
    trace = @current_project.trace.find(params[:trace_id])
    trace.destroy
    flash[:notice] = "Deleted trace #{trace.id}"
    redirect_to :action => :traces
  end
  
  def scans
    @shadow_scans = @current_project.shadow_scans.find(:all, :order => "id DESC")

    @schools = @current_project.schools.find(:all)
    @modes = @current_project.modes.find(:all)
  end
  
  def scan_remove
    assert_method :post
    
    scan = @current_project.shadow_scans.find(params[:scan_id])
    scan.destroy
    flash[:notice] = "Deleted details of scan #{scan.scan_id}"
    redirect_to :action => :scans
  end
  
  def schools
    @schools = @current_project.schools.find(:all)
  end
  
  def modes
    @modes = @current_project.modes.find(:all)
  end
  
  def settings
    @project = @current_project
  end
  
  def aliases
    #TODO rewrite aliases as proper objects, and use them throughout all the rest of the code
    @aliases = []
    @scans = {}
    @traces = {}
    @current_project.shadow_scans.find(:all, :select => 'count(*) as scans, alias', :group => 'alias').each do |a|
      @aliases << a.alias
      @scans[a.alias] = a.scans
    end
    @current_project.traces.find(:all, :select => 'count(*) as traces, alias', :group => 'alias', :conditions => "alias is not null and alias != ''").each do |a|
      @aliases << a.alias
      @traces[a.alias] = a.traces
    end
    @aliases.uniq!
  end

  def emotions
    @emotions = @current_project.emotions.find(:all)
  end
end
