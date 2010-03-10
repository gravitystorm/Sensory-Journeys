class TraceController < ApplicationController
  require 'xml/libxml'
  include XML
  
  def index
    @traces = Trace.find(:all)
  end
  
  def upload
  end
  
  def uploadFile
    t = Trace.new()
    t.file_name = params[:upload]['gpx'].original_filename
    t.save!
    
    parser = XML::Parser.new()
    parser.string = params[:upload]['gpx'].read
    doc = parser.parse
    
    doc.find('//g:trkpt', 'g:http://www.topografix.com/GPX/1/1').each do |trkpt|
      pt = TracePoint.new()
      pt.lat = trkpt["lat"]
      pt.lon = trkpt["lon"]
      pt.timestampe = trkpt["timestamp"]
      pt.trace_id = t.id
      pt.save!
    end
    
    flash[:notice] = "foo"
    #redirect_to(:action => :view, :id => t.id)
    redirect_to(:action => :upload)
  end
end
