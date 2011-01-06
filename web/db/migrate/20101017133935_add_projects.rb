class AddProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :subdomain
      t.timestamps
    end

    execute("insert into projects default values") # keeps the sequence happy

    add_column :markers, :project_id, :integer
    execute("update markers set project_id = 1")

    add_column :modes, :project_id, :integer
    execute("update modes set project_id = 1")

    add_column :schools, :project_id, :integer
    execute("update schools set project_id = 1")

    add_column :shadow_scans, :project_id, :integer
    execute("update shadow_scans set project_id = 1")

    add_column :traces, :project_id, :integer
    execute("update traces set project_id = 1")
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
