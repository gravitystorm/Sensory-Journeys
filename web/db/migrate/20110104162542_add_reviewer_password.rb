class AddReviewerPassword < ActiveRecord::Migration
  def self.up
    add_column :projects, :reviewer_password, :string
    Project.find(:all).each {|project| project.save}
  end

  def self.down
    remove_column :projects, :reviewer_password
  end
end
