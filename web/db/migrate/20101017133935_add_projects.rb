class AddProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :subdomain
      t.timestamps
    end

    add_column :markers, :project_id, :integer
    add_column :modes, :project_id, :integer
    add_column :schools, :project_id, :integer
    add_column :shadow_scans, :project_id, :integer
    add_column :traces, :project_id, :integer
  end

  def self.down
    drop_table :projects

    remove_column :markers, :project_id
    remove_column :modes, :project_id
    remove_column :schools, :project_id
    remove_column :shadow_scans, :project_id
    remove_column :traces, :project_id
  end
end
