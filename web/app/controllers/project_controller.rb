class ProjectController < ApplicationController

  before_filter :authorize
  before_filter :require_admin

  # These all need hefty validations

  def set_home_location_lat
    unless [:post, :put].include?(request.method) then
            return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.home_location_lat = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.home_location_lat.to_s)
  end

  def set_home_location_lon
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.home_location_lon = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.home_location_lon.to_s)
  end

  def set_home_location_zoom
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.home_location_zoom = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.home_location_zoom.to_s)
  end

  def set_max_markers
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.max_markers = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.max_markers.to_s)
  end

  def set_max_traces
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.max_traces = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.max_traces.to_s)
  end

  def set_max_trace_point_summary
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.max_trace_point_summary = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.max_trace_point_summary.to_s)
  end

  def set_max_waypoint_summary
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.max_waypoint_summary = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.max_waypoint_summary.to_s)
  end

  def set_gps_not_before
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.gps_not_before = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.gps_not_before.to_s)
  end

  def set_gps_not_after
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.gps_not_after = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.gps_not_after.to_s)
  end

  def set_dp_threshold
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.dp_threshold = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.dp_threshold.to_s)
  end

  def set_user_password
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.user_password = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.user_password)
  end

  def set_reviewer_password
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.reviewer_password = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.reviewer_password)
  end

  def set_admin_password
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.admin_password = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.admin_password)
  end

  def set_location_text
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.location_text = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.location_text)
  end

  def set_project_name
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @current_project.project_name = params[:value]
    @current_project.save!
    render :text => CGI::escapeHTML(@current_project.project_name)
  end

end