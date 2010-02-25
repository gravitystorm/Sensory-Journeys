class CreateTraces < ActiveRecord::Migration
  def self.up
    create_table :traces do |t|
      t.references :user
      t.string :file_name
      t.boolean :inserted
      t.string :transport

      t.timestamps
    end
  end

  def self.down
    drop_table :traces
  end
end
