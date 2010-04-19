class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :markers, :lat
    add_index :markers, :lon
    add_index :markers, :user_id
    
    add_index :trace_points, :trace_id
    
    add_index :traces, :min_lat
    add_index :traces, :min_lon
    add_index :traces, :max_lat
    add_index :traces, :max_lon
    add_index :traces, :user_id
    add_index :traces, :mode_id
    
    add_index :waypoints, :trace_id
  end

  def self.down
    remove_index :markers, :lat
    remove_index :markers, :lon
    remove_index :markers, :user_id
    
    remove_index :trace_points, :trace_id
    
    remove_index :traces, :min_lat
    remove_index :traces, :min_lon
    remove_index :traces, :max_lat
    remove_index :traces, :max_lon
    remove_index :traces, :user_id
    remove_index :traces, :mode_id
    
    remove_index :waypoints, :trace_id
  end
end
