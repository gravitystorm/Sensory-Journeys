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
    redirect_to(:controller => :site, :action=> :edit)
  end
  
  def all
    # This will have bbox parameters at some point in the future
    if params[:bbox]
      minlon, minlat, maxlon, maxlat = params[:bbox].split(",").collect{|i| i.to_f}
      # @markers = Marker.find(:lat > minlat, :lon > minlon, :lat < maxlat, :lon < maxlon)
      @markers = Marker.find(:all, :conditions => ["lat > ? AND lon > ? AND lat < ? AND lon < ?", minlat, minlon, maxlat, maxlon],
                             :limit => 50, :order => "created_at DESC")
    else
      @markers = Marker.find(:all)
    end
    # TODO use correct Content-type
  end

end