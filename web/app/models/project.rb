class Project < ActiveRecord::Base
  has_many :markers
  has_many :modes
  has_many :schools
  has_many :shadow_scans
  has_many :traces
  has_many :emotions

  before_save :default_values
  def default_values
    self.home_location_lat ||= 51.45855
    self.home_location_lon ||= -2.58391
    self.home_location_zoom ||= 13
    self.max_markers ||= 40
    self.max_traces ||= 5
    self.max_trace_points_summary ||= 500
    self.max_waypoints_summary ||= 25
    self.gps_not_before ||= 7
    self.gps_not_after ||= 20
    self.user_password ||= 'go'
    self.reviewer_password ||= 'hybrid'
    self.admin_password ||= '26inchMTB'
    self.dp_threshold ||= '0.0002'
    self.location_text ||= 'location'
    self.project_name ||= 'Emotion Mapping'
  end

end