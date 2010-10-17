class Mode < ActiveRecord::Base
  belongs_to :project

  has_many :traces
  has_many :shadow_scans
  
  default_scope :order => :id
  
end
