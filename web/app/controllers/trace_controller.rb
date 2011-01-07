class TraceController < ApplicationController
  require 'xml/libxml'
  require 'RMagick'
  include XML
  
  before_filter :authorize
  before_filter :require_user, :only => [:uploadFile]
  before_filter :require_admin, :only => [:set_trace_alias]
  
  in_place_edit_for :trace, :alias
  
  #in_place_edit_for :trace, :school_id  -- would return id instead of name when called
  def set_trace_school_id
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @trace = @current_project.trace.find(params[:id])
    @trace.school_id = params[:value]
    @trace.save
    render :text => CGI::escapeHTML(@trace.school.name)
  end
  
  #in_place_edit_for :trace, :mode_id
  def set_trace_mode_id
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @trace = @current_project.traces.find(params[:id])
    @trace.mode_id = params[:value]
    @trace.save
    render :text => CGI::escapeHTML(@trace.mode.name)
  end
  
  def index
    @traces = @current_project.traces.find(:all)
  end
  
  def upload
    @schools = @current_project.schools.find(:all)
    @modes = @current_project.modes.find(:all)
  end
  
  def view
    @trace = @current_project.traces.find(params[:id])
  end
  
  def kml
    @traces = [@current_project.traces.find(params[:id])] # array of traces
    render "traces.kml", :layout => false
  end

  def all
    if params[:school] && params[:mode]
      @traces = @current_project.traces.find(:all, :conditions => ["school_id = ? AND mode_id = ?", params[:school], params[:mode]])
    elsif params[:school]
      @traces = @current_project.traces.find(:all, :conditions => ["school_id = ?", params[:school]])
    elsif params[:mode]
      @traces = @current_project.traces.find(:all, :conditions => ["mode_id = ?", params[:mode]])
    else
      @traces = @current_project.traces.find(:all)
    end
    if @traces && @traces.length > 0
      render "traces.kml", :layout => false
    else
      render :nothing => :true, :status => :not_found
    end
  end

  def traces
    bboxString = "(min_lat+max_lat)/2 > :minlat AND (min_lon+max_lon)/2  > :minlon AND (min_lat+max_lat)/2 < :maxlat AND (min_lon+max_lon)/2  < :maxlon"
    
    conditions = []
    arguments = {}
    
    if params[:bbox]
      arguments[:minlon], arguments[:minlat], arguments[:maxlon], arguments[:maxlat] = params[:bbox].split(",").collect{|i| i.to_f}
      conditions << bboxString
    end
    
    if params[:mode]
      arguments[:mode] = params[:mode]
      conditions << "mode_id = :mode"
    end
    
    if params[:user] && params[:alias]
      arguments[:user] = params[:user]
      arguments[:alias] = params[:alias]
      conditions << "(user_id = :user OR alias = :alias)"
    elsif params[:user]
      arguments[:user] = params[:user]
      conditions << "user_id = :user"
    elsif params[:alias]
      arguments[:alias] = params[:alias]
      conditions << "alias = :alias"
    end
    
    all_conditions = conditions.join(' AND ')
    
    @traces = @current_project.traces.find(:all, :conditions => [all_conditions, arguments], :limit => @current_project.max_traces, :order => "created_at DESC")
  end
  
  def uploadFile
    if params[:upload] && params[:mode] && params[:school]
      t = @current_project.traces.new()
      t.file_name = params[:upload]['gpx'].original_filename
      t.mode_id = params[:mode]
      t.school_id = params[:school]
      t.alias = params[:alias]
      t.user_id = @user.id
      t.save!

      gpx = GPX::File.new(StringIO.new(params[:upload]['gpx'].read))
      
      hasPoints = false
      hasWaypoints = false
      
      # simplify the gpx trace before inserting into the database
      dp = DpSimplify::LineString.new

      list = []
      gpx.points do |point|
        list << point
      end
      
      #need to simplify trksegs individually, otherwise they can end up
      #with only one point (not good for rendering a line)
      seglist = []
      simpleList = []
      #build a list of segments containing their points
      list.each do |point|
        seglist[point.segment] = [] unless seglist[point.segment]
        seglist[point.segment] << point
      end
      #simplify each segment, and add the remaining points to the overall
      #points list
      seglist.each do |seg|
        next if !seg || seg.length == 1 #some segments will be zero-length since all their points were invalid
          dp.simplify(seg).each do |point|
          simpleList << point
        end
      end
      
      # Add the simplified points to the db
      simpleList.each do |trkpt|
        pt = TracePoint.new()
        pt.lat = trkpt.latitude.to_f
        pt.lon = trkpt.longitude.to_f
        t.min_lat = pt.lat if t.min_lat == nil || t.min_lat > pt.lat
        t.max_lat = pt.lat if t.max_lat == nil || t.max_lat < pt.lat
        t.min_lon = pt.lon if t.min_lon == nil || t.min_lon > pt.lon
        t.max_lon = pt.lon if t.max_lon == nil || t.max_lon < pt.lon
        pt.timestamp = trkpt["timestamp"]
        pt.trace_id = t.id
        pt.segment = trkpt.segment
        pt.save!
        hasPoints = true
      end
      
      gpx.waypoints do |waypoint|
        wp = Waypoint.new()
        wp.lat = waypoint.latitude.to_f
        wp.lon = waypoint.longitude.to_f
        # not sure if this is a good idea, since some GPS units save all existing
        # waypoints with every GPX file - could cover a large area 
        t.min_lat = wp.lat if t.min_lat == nil || t.min_lat > wp.lat
        t.max_lat = wp.lat if t.max_lat == nil || t.max_lat < wp.lat
        t.min_lon = wp.lon if t.min_lon == nil || t.min_lon > wp.lon
        t.max_lon = wp.lon if t.max_lon == nil || t.max_lon < wp.lon
        wp.timestamp = waypoint["timestamp"]
        wp.trace_id = t.id
        wp.save!
        hasWaypoints = true
      end
      
      unless (hasPoints || hasWaypoints)
        t.delete
        flash[:error] = "There were no tracepoints and no waypoints in that file. Are you sure it was a GPX file?"
        redirect_to(:controller => :site, :action => :edit) and return
      end
      
      #TODO check number of trace points - if zero then don't commit
      t.inserted = true
      t.save!
      
      #flash[:notice] = "You went to #{params[:school]} and used #{params[:mode]} "
      #flash[:notice] = "#{t.min_lat} #{t.max_lat} #{t.min_lon} #{t.max_lon}"
      #redirect_to(:action => :view, :id => t.id)
      #flash[:notice] = "Found #{waypointCount} waypoints"
      redirect_to(:controller => :site, :action => :edit, :trace => t.id)
    else
      flash[:notice] = "You need to fill in everything when uploading a trace"
      redirect_to(:controller => :site, :action => :edit)
    end
  end

  def image
    x = params[:x]
    y = params[:y]
    z = params[:z]
    trace = Trace.find(92)

    canvas = Magick::Image.new(256,256, Magick::HatchFill.new('white','lightcyan2'))
    gc = Magick::Draw.new

    gc.stroke('blue')
    gc.stroke_width(5)

    plat = nil
    plon = nil
    pseg = nil
    strokes = 0
    trace.trace_points.each do |tp|
      if plat && plon && pseg
        if(tp.segment == pseg)
          gc.line(plat,plon,tp.lat,tp.lon.abs)
          strokes += 1
        end
      end
      plat = tp.lat
      plon = tp.lon.abs
      pseg = tp.segment
    end

    sph = latlon2sphm({:lat => plat, :lon => plon})

    gc.stroke('transparent')
    gc.text(5,50,"#{@current_project.id}")
    gc.text(5,70,"x = #{x}")
    gc.text(5,90,"y = #{y}")
    gc.text(5,110,"z = #{z}")
    gc.text(5,130,"strokes = #{strokes}")
    gc.text(5,150,"lat = #{plat}")
    gc.text(5,170,"lon = #{plon}")
    gc.text(5,190,"sphlat = #{sph[:lat]}")
    gc.text(5,210,"sphlon = #{sph[:lon]}")

    gc.draw(canvas)
    canvas.format = 'png'
    send_data(canvas.to_blob,:type => 'image/png', :disposition => 'inline')
  end

  private
  def latlon2sphm(ll)
    sphlat = Math.log(Math.tan((90 + ll[:lat]) * Math::PI / 360)) / (Math::PI / 180)
    sphlon = ll[:lon] * 20037508.34 / 180
    {:lat => sphlat, :lon => sphlon}
  end
end
