class TracesAddAlias < ActiveRecord::Migration
  def self.up
    add_column :traces, :alias, :text
  end

  def self.down
    remove_column :traces, :alias
  end
end
