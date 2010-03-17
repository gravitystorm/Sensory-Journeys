class Trace < ActiveRecord::Base
  require 'xml/libxml'
  include XML
  
  has_many :trace_points
  
  def to_kml
    output = XML::Document.new
    output.root = XML::Node.new('kml')
    output.root['xmlns'] = 'http://www.opengis.net/kml/2.2'
    
    document = XML::Node.new('Document')
    output.root << document
    
    name = XML::Node.new('name', self.file_name)
    document << name

    style = XML::Node.new('Style')
    style['id'] = 'd'
    document << style
    
    linestyle = XML::Node.new('LineStyle')
    style << linestyle
    color = XML::Node.new('color', '7f00ffff')
    width = XML::Node.new('width', '4')
    linestyle << color
    linestyle << width

    placemark = XML::Node.new('Placemark')
    document << placemark
    
    styleUrl = XML::Node.new('styleUrl', '#d')
    placemark << styleUrl
    
    linestring = XML::Node.new('LineString')
    placemark << linestring
    
    coords = ''
    self.trace_points.each do |tp|
      coords += "#{tp.lon},#{tp.lat} \n"
    end
    coordinates = XML::Node.new('coordinates', coords)
    linestring << coordinates
# 
#     markers = doc.find('marker')
#     markers.each do |marker|
#       placemark = XML::Node.new('Placemark')
#       output.root << placemark
#       name = XML::Node.new('name', marker[:name])
#       desc = XML::Node.new('description', '<p>'+marker[:length]+'</p>')
#       styleurl = XML::Node.new('styleUrl', '#mtb_hard_normal')
#       point = XML::Node.new('Point')
#       placemark << name
#       placemark << desc
#       placemark << styleurl
#       placemark << point
#       coord = XML::Node.new('coordinates', marker[:lng]+','+marker[:lat]+',0')
#       point << coord
#     end
    
    return output
  end
end
