class CreateTracePoints < ActiveRecord::Migration
  def self.up
    create_table :trace_points do |t|
      t.float :lat
      t.float :lon
      t.datetime :timestamp
      t.references :trace

      t.timestamps
    end
  end

  def self.down
    drop_table :trace_points
  end
end
