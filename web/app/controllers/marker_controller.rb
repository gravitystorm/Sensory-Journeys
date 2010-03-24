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
    redirect_to(:controller => :trace, :action=> :view, :id => params[:trace_id])
  end
  
  def all
    # This will have bbox parameters at some point in the future
    @markers = Marker.find(:all)
    # TODO use correct Content-type
  end

end