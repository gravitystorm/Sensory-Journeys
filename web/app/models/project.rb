class Project < ActiveRecord::Base
  has_many :markers
  #has_many :settings
  has_many :modes
  has_many :schools
  has_many :shadow_scans
  has_many :traces
  has_many :emotions
end