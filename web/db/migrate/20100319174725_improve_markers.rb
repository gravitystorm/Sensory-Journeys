class ImproveMarkers < ActiveRecord::Migration
  def self.up
    remove_column :markers, :test
    add_column :markers, :text, :text
    add_column :markers, :lat, :float
    add_column :markers, :lon, :float
  end

  def self.down
    add_column :markers, :test, :string
    remove_column :markers, :text
    remove_column :markers, :lat
    remove_column :markers, :lon
  end
end
