class AddSettingsToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :home_location_lat, :float
    add_column :projects, :home_location_lon, :float
    add_column :projects, :home_location_zoom, :integer
    add_column :projects, :max_markers, :integer
    add_column :projects, :max_traces, :integer
    add_column :projects, :max_trace_points_summary, :integer
    add_column :projects, :max_waypoints_summary, :integer
    add_column :projects, :gps_not_before, :integer
    add_column :projects, :gps_not_after, :integer
    add_column :projects, :user_password, :string
    add_column :projects, :admin_password, :string
    add_column :projects, :dp_threshold, :float
    add_column :projects, :location_text, :string
    add_column :projects, :project_name, :string
  end

  def self.down
    remove_column :projects, :home_location_lat
    remove_column :projects, :home_location_lon
    remove_column :projects, :home_location_zoom
    remove_column :projects, :max_markers
    remove_column :projects, :max_traces
    remove_column :projects, :max_trace_points_summary
    remove_column :projects, :max_waypoints_summary
    remove_column :projects, :gps_not_before
    remove_column :projects, :gps_not_after
    remove_column :projects, :user_password
    remove_column :projects, :admin_password
    remove_column :projects, :dp_threshold
    remove_column :projects, :location_text
    remove_column :projects, :project_name
  end
end
