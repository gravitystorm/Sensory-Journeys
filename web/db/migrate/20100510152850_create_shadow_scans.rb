class CreateShadowScans < ActiveRecord::Migration
  def self.up
    create_table :shadow_scans do |t|
      t.text :scan_id
      t.references :school
      t.references :mode
      t.references :user
      t.text :alias

      t.timestamps
    end
  end

  def self.down
    drop_table :shadow_scans
  end
end
