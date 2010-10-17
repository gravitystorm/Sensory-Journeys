class AdminController < ApplicationController
  
  before_filter :authorize
  before_filter :require_admin
  
  def index
    @markers = Marker.find(:all)
    @scans = ShadowScan.find(:all)
    @traces = Trace.find(:all)
    @schools = School.find(:all)
    @modes = Mode.find(:all)
  end
  
  def markers
    @markers = Marker.find(:all, :order => "id DESC")
  end
  
  def marker_delete
    assert_method :post
    
    marker = Marker.find(params[:marker_id])
    marker.delete
    flash[:notice] = "Deleted marker #{marker.id}"
    redirect_to :action => :markers
  end
  
  def traces
    @traces = Trace.find(:all, :order => "id DESC")
    @schools = School.find(:all, :order => "id DESC")
    @modes = Mode.find(:all, :order => "id DESC")
  end
  
  def trace_delete
    assert_method :post
    
    trace = Trace.find(params[:trace_id])
    trace.destroy
    flash[:notice] = "Deleted trace #{trace.id}"
    redirect_to :action => :traces
  end
  
  def scans
    @shadow_scans = ShadowScan.find(:all, :order => "id DESC")
    @wp_scans = Wpscan.find(:all, :order => "created DESC")
    
    @unclaimed_scans = []
    # This is a horrid way to ensure the system grinds to an eventual halt
    @wp_scans.each do |scan|
      @unclaimed_scans << scan unless ShadowScan.find_by_scan_id(scan.id)
    end
    @schools = School.find(:all)
    @modes = Mode.find(:all)
  end
  
  def scan_remove
    assert_method :post
    
    scan = ShadowScan.find(params[:scan_id])
    scan.destroy
    flash[:notice] = "Deleted details of scan #{scan.scan_id}, which will now appear in the unprocessed list"
    redirect_to :action => :scans
  end
  
  def schools
    @schools = School.find(:all)
  end
  
  def modes
    @modes = @current_project.modes.find(:all)
  end
  
  def settings
  end
  
  def aliases
    #TODO rewrite aliases as proper objects, and use them throughout all the rest of the code
    @aliases = []
    @scans = {}
    @traces = {}
    ShadowScan.find(:all, :select => 'count(*) as scans, alias', :group => 'alias').each do |a|
      @aliases << a.alias
      @scans[a.alias] = a.scans
    end
    Trace.find(:all, :select => 'count(*) as traces, alias', :group => 'alias', :conditions => "alias is not null and alias != ''").each do |a|
      @aliases << a.alias
      @traces[a.alias] = a.traces
    end
    @aliases.uniq!
  end
end
