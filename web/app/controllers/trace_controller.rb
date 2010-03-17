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
  
  def uploadFile
    #TODO - a bucketon of error handling
    # dodgy and/or empty values for mode, school
    # broken gpx file
    t = Trace.new()
    t.file_name = params[:upload]['gpx'].original_filename
    t.mode_id = params[:mode]
    t.school_id = params[:school]
    
    parser = XML::Parser.new()
    parser.string = params[:upload]['gpx'].read
    doc = parser.parse
    
    doc.find('//g:trkpt', 'g:http://www.topografix.com/GPX/1/1').each do |trkpt|
      pt = TracePoint.new()
      pt.lat = trkpt["lat"].to_f
      pt.lon = trkpt["lon"].to_f
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
    flash[:notice] = "#{t.min_lat} #{t.max_lat} #{t.min_lon} #{t.max_lon}"
    #redirect_to(:action => :view, :id => t.id)
    redirect_to(:action => :upload)
  end
end
