class AdminController < ApplicationController
  
  before_filter :authorize
  before_filter :require_admin
  
  def index
    @markers = Marker.find(:all)
    @scans = ShadowScan.find(:all)
    @traces = Trace.find(:all)
    @schools = School.find(:all)
  end
  
  def markers
    @markers = Marker.find(:all, :order => :id)
  end
  
  def marker_delete
    assert_method :post
    
    marker = Marker.find(params[:marker_id])
    marker.delete
    flash[:notice] = "Deleted marker #{marker.id}"
    redirect_to :action => :markers
  end
  
  def traces
    @traces = Trace.find(:all, :order => :id)
  end
  
  def trace_delete
    assert_method :post
    
    trace = Trace.find(params[:trace_id])
    trace.destroy
    flash[:notice] = "Deleted trace #{trace.id}"
    redirect_to :action => :traces
  end
  
  def scans
    @shadow_scans = ShadowScan.find(:all, :order => :id)
    @wp_scans = Wpscan.find(:all)
    
    @unclaimed_scans = []
    # This is a horrid way to ensure the system grinds to an eventual halt
    @wp_scans.each do |scan|
      @unclaimed_scans << scan unless ShadowScan.find_by_scan_id(scan.id)
    end
  end
end
