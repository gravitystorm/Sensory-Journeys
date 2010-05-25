class ShadowScanController < ApplicationController
  
  before_filter :authorize
  before_filter :require_user
  before_filter :require_admin, :only => [:set_scan_alias]
  
  in_place_edit_for :shadow_scan, :alias
  
  #in_place_edit_for :shadow_scan, :school_id
  def set_shadow_scan_school_id
    unless [:post, :put].include?(request.method) then
      return render(:text => 'Method not allowed', :status => 405)
    end
    @scan = ShadowScan.find(params[:id])
    @scan.school_id = params[:value]
    @scan.save
    render :text => CGI::escapeHTML(@scan.school.name)
  end
  
  def claim
    #TODO - handle bogus claims
    #TODO - handle claims already made
    @wp = Wpscan.find_by_id(params[:id])
    @schools = School.find(:all)
    @modes = Mode.find(:all)
  end
  
  def doClaim
    s = ShadowScan.new
    s.user_id = @user.id
    s.scan_id = params[:scan] # validate?
    s.alias = params[:alias]
    s.mode_id = params[:mode] # validate?
    s.school_id = params[:school] #validate?
    s.save
    redirect_to(:controller => :site, :action => :edit, :scan => s.scan_id)
  end
end
