class TraceController < ApplicationController
  require 'xml/libxml'
  include XML
  
  def index
    @traces = Trace.find(:all)
  end
  
  def upload
    @schools = School.find(:all)
    # need to change this to an array of objects: spaces break label_for tags
    @modes = Mode.find(:all)
  end
  
  def view
    @trace = Trace.find(params[:id])
  end
  
  def kml
    # TODO use correct Content-type
    send_data Trace.find(params[:id]).to_kml.to_s, :type => "text/plain", :disposition => 'inline'
  end
  
  def traces
    if params[:bbox]
      minlon, minlat, maxlon, maxlat = params[:bbox].split(",").collect{|i| i.to_f}
      if params[:mode]
        mode_id = params[:mode]
        @traces = Trace.find(:all, :conditions => ["(min_lat+max_lat)/2 > ? AND (min_lon+max_lon)/2  > ? AND (min_lat+max_lat)/2 < ? AND (min_lon+max_lon)/2  < ? AND mode_id = ?", minlat, minlon, maxlat, maxlon, mode_id],
                             :limit => MAX_TRACES, :order => "created_at DESC")
      else
        @traces = Trace.find(:all, :conditions => ["(min_lat+max_lat)/2 > ? AND (min_lon+max_lon)/2  > ? AND (min_lat+max_lat)/2 < ? AND (min_lon+max_lon)/2  < ?", minlat, minlon, maxlat, maxlon],
                             :limit => MAX_TRACES, :order => "created_at DESC")
      end
    else
      @traces = Trace.find(:all, :limit=> MAX_TRACES, :order => "created_at DESC")
    end
  end
  
  def uploadFile
    # TODO - a bucketon of error handling
    # dodgy and/or empty values for mode, school
    # broken gpx file
    t = Trace.new()
    t.file_name = params[:upload]['gpx'].original_filename
    t.mode_id = params[:mode]
    t.school_id = params[:school]
    t.save!

    gpx = GPX::File.new(StringIO.new(params[:upload]['gpx'].read))
    
    gpx.points do |trkpt|
      pt = TracePoint.new()
      pt.lat = trkpt.latitude.to_f
      pt.lon = trkpt.longitude.to_f
      t.min_lat = pt.lat if t.min_lat == nil || t.min_lat > pt.lat
      t.max_lat = pt.lat if t.max_lat == nil || t.max_lat < pt.lat
      t.min_lon = pt.lon if t.min_lon == nil || t.min_lon > pt.lon
      t.max_lon = pt.lon if t.max_lon == nil || t.max_lon < pt.lon
      pt.timestamp = trkpt["timestamp"]
      pt.trace_id = t.id
      pt.save!
    end
    
    t.inserted = true
    t.save!
    
    #flash[:notice] = "You went to #{params[:school]} and used #{params[:mode]} "
    #flash[:notice] = "#{t.min_lat} #{t.max_lat} #{t.min_lon} #{t.max_lon}"
    #redirect_to(:action => :view, :id => t.id)
    redirect_to(:controller => :site, :action => :edit, :trace => t.id)
  end
end
