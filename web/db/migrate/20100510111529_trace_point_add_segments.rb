class TracePointAddSegments < ActiveRecord::Migration
  def self.up
    add_column :trace_points, :segment, :integer, {:default => 1}
  end

  def self.down
    remove_column :trace_points, :segment
  end
end
