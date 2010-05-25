class MarkerController < ApplicationController
  require 'xml/libxml'
  include XML
  
  in_place_edit_for :marker, :text
  
  before_filter :authorize
  before_filter :require_user, :only => [:save]
  before_filter :require_admin, :only => [:set_marker_text]
  
  def view
  end
  
  def save
    m = Marker.new()
    m.lat = params[:lat]
    m.lon = params[:lon]
    m.text = params[:text]
    m.emotion = params[:emotion]
    m.user_id = @user.id
    m.save!
    redirect_to(:controller => :site, :action=> :edit)
  end
  
  def all
    if params[:bbox]
      minlon, minlat, maxlon, maxlat = params[:bbox].split(",").collect{|i| i.to_f}
      @markers = Marker.find(:all, :conditions => ["lat > ? AND lon > ? AND lat < ? AND lon < ?", minlat, minlon, maxlat, maxlon],
                             :limit => MAX_MARKERS, :order => "created_at DESC")
    else
      @markers = Marker.find(:all)
    end
  end

end