class ModeController < ApplicationController

  before_filter :authorize
  before_filter :require_admin
  
  in_place_edit_for :mode, :name
  
  def add
    m = Mode.new
    m.name = params[:name]
    m.save!
    
    flash[:notice] = "Added new mode"
    redirect_to(:controller => :admin, :action => :modes)
  end
  
  def delete
    m = Mode.find_by_id(params[:mode_id])
    if m.traces.count == 0 && m.shadow_scans.count == 0
      m.destroy
      flash[:notice] = "Mode deleted"
    else
      flash[:error] = "Mode has either traces or scans, so not deleted"
    end
    
    redirect_to(:controller => :admin, :action => :modes)
  end

end