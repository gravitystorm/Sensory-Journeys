class MarkerController < ApplicationController
  require 'xml/libxml'
  include XML
  
  def view
  end
  
  def save
    m = Marker.new()
    m.lat = params[:lat]
    m.lon = params[:lon]
    m.text = params[:text]
    m.emotion = params[:emotion]
    m.save!
    redirect_to(:controller => :trace, :action=> :view, :id => 13)
  end
  
  def all
    # This will have bbox parameters at some point in the future
    markers = Marker.find(:all)
    # TODO use correct Content-type
    send_data to_kml(markers).to_s, :type => "text/plain", :disposition => 'inline'
  end
  
  # TODO this should be private
  def to_kml(markers)
    output = XML::Document.new
    output.root = XML::Node.new('kml')
    output.root['xmlns'] = 'http://www.opengis.net/kml/2.2'
    
    document = XML::Node.new('Document')
    output.root << document
    
    style = XML::Node.new('Style')
    style['id'] = 'happy'
    document << style
    
    # define styles here for happy, sad etc
#     linestyle = XML::Node.new('LineStyle')
#     style << linestyle
#     color = XML::Node.new('color', '7f00ffff')
#     width = XML::Node.new('width', '4')
#     linestyle << color
#     linestyle << width
    markers.each do |marker|
      placemark = XML::Node.new('Placemark')
      document << placemark
      
      name = XML::Node.new('name', marker.id.to_s)
      description = XML::Node.new('description', marker.text)
      styleUrl = XML::Node.new('styleUrl', '#happy') #TODO actually use the emotion
      placemark << name
      placemark << description
      placemark << styleUrl
      point = XML::Node.new('Point')
      coordinates = XML::Node.new('coordinates', marker.lon.to_s + "," + marker.lat.to_s + ",0")
      placemark << point 
      point << coordinates
    end
    
    return output
  end
end