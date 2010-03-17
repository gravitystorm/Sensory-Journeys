class AddSchoolsToTraces < ActiveRecord::Migration
  def self.up
    add_column :traces, :school_id, :integer
  end

  def self.down
    remove_column :traces, :school_id
  end
end
