class SchoolController < ApplicationController

  before_filter :authorize
  before_filter :require_admin
  
  in_place_edit_for :school, :name
  in_place_edit_for :school, :lat
  in_place_edit_for :school, :lon

  def add
    s = School.new
    s.name = params[:name]
    s.lat = params[:lat]
    s.lon = params[:lon]
    s.save!
    
    flash[:notice] = "Added new school"
    redirect_to(:controller => :admin, :action => :schools)
  end
  
  def delete
    s = School.find_by_id(params[:school_id])
    if s.traces.count == 0 && s.shadow_scans.count == 0
      s.destroy
      flash[:notice] = "School deleted"
    else
      flash[:error] = "School has either traces or scans, so not deleted"
    end
    
    redirect_to(:controller => :admin, :action => :schools)
  end
end