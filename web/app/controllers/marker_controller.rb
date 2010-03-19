class MarkerController < ApplicationController
  def save
    m = Marker.new()
    m.lat = params[:lat]
    m.lon = params[:lon]
    m.text = params[:text]
    m.emotion = params[:emotion]
    m.save!
    redirect_to(:controller => :trace, :action=> :view, :id => 13)
  end
end