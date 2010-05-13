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
end
