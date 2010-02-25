class CreateMarkers < ActiveRecord::Migration
  def self.up
    create_table :markers do |t|
      t.references :user
      t.string :emotion
      t.string :test

      t.timestamps
    end
  end

  def self.down
    drop_table :markers
  end
end
