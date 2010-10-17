class SchoolController < ApplicationController

  before_filter :authorize
  before_filter :require_admin
  
  in_place_edit_for :school, :name
  in_place_edit_for :school, :lat
  in_place_edit_for :school, :lon

  def add
    s = @current_project.schools.new
    s.name = params[:name]
    s.lat = params[:lat]
    s.lon = params[:lon]
    s.save!
    
    flash[:notice] = "Added new " + CGI::escapeHTML(Settings.location_text)
    redirect_to(:controller => :admin, :action => :schools)
  end
  
  def delete
    s = @current_project.schools.find_by_id(params[:school_id])
    if s.traces.count == 0 && s.shadow_scans.count == 0
      s.destroy
      flash[:notice] = CGI::escapeHTML(Settings.location_text.capitalize)+" deleted"
    else
      flash[:error] = CGI::escapeHTML(Settings.location_text.capitalize)+" has either traces or scans, so not deleted"
    end
    
    redirect_to(:controller => :admin, :action => :schools)
  end
end