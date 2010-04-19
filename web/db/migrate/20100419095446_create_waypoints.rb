class CreateWaypoints < ActiveRecord::Migration
  def self.up
    create_table :waypoints do |t|
      t.float :lat
      t.float :lon
      t.datetime :timestamp
      t.references :trace

      t.timestamps
    end
  end

  def self.down
    drop_table :waypoints
  end
end
