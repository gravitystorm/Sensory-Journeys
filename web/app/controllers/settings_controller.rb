class SettingsController < ApplicationController
  
  before_filter :authorize
  before_filter :require_admin
  
  # These all need hefty validations
  
  def set_home_location_lat
    unless [:post, :put].include?(request.method) then
            return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.home_location_lat = params[:value]
    render :text => CGI::escapeHTML(Settings.home_location_lat)
  end
  
  def set_home_location_lon
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.home_location_lon = params[:value]
    render :text => CGI::escapeHTML(Settings.home_location_lon)
  end
  
  def set_home_location_zoom
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.home_location_zoom = params[:value]
    render :text => CGI::escapeHTML(Settings.home_location_zoom)
  end
  
  def set_max_markers
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.max_markers = params[:value]
    render :text => CGI::escapeHTML(Settings.max_markers)
  end
  
  def set_max_traces
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.max_traces = params[:value]
    render :text => CGI::escapeHTML(Settings.max_traces)
  end
  
  def set_max_trace_point_summary
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.max_trace_point_summary = params[:value]
    render :text => CGI::escapeHTML(Settings.max_trace_point_summary)
  end
  
  def set_max_waypoint_summary
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.max_waypoint_summary = params[:value]
    render :text => CGI::escapeHTML(Settings.max_waypoint_summary)
  end  
  
  def set_gps_not_before
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.gps_not_before = params[:value]
    render :text => CGI::escapeHTML(Settings.gps_not_before)
  end
  
  def set_gps_not_after
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.gps_not_after = params[:value]
    render :text => CGI::escapeHTML(Settings.gps_not_after)
  end
  
  def set_dp_threshold
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.dp_threshold = params[:value]
    render :text => CGI::escapeHTML(Settings.dp_threshold)
  end
  
  def set_user_password
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.user_password = params[:value]
    render :text => CGI::escapeHTML(Settings.user_password)
  end
  
  def set_admin_password
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.admin_password = params[:value]
    render :text => CGI::escapeHTML(Settings.admin_password)
  end

  def set_location_text
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    Settings.location_text = params[:value]
    render :text => CGI::escapeHTML(Settings.location_text)
  end
  
  
end