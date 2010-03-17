class MoreTraceAttributes < ActiveRecord::Migration
  def self.up
    remove_column :traces, :transport
    add_column :traces, :mode_id, :integer
    add_column :traces, :min_lat, :float
    add_column :traces, :max_lat, :float
    add_column :traces, :min_lon, :float
    add_column :traces, :max_lon, :float
  end

  def self.down
    add_column :traces, :transport, :string
    remove_column :traces, :mode
    remove_column :traces, :min_lat
    remove_column :traces, :max_lat
    remove_column :traces, :min_lon
    remove_column :traces, :max_lon
  end
end
