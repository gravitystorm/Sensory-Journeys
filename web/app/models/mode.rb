class Mode < ActiveRecord::Base
  belongs_to :project

  has_many :traces
  has_many :shadow_scans

  validates_presence_of :project_id
  validates_associated :project
  
  default_scope :order => :id
  
end
