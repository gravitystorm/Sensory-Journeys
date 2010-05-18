class School < ActiveRecord::Base
  has_many :traces
  has_many :shadow_scans
end
