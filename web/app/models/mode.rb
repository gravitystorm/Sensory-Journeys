class Mode < ActiveRecord::Base
  has_many :traces
  has_many :shadow_scans
  
  default_scope :order => :id
  
end
