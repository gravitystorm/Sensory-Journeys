class User < ActiveRecord::Base
  has_many :traces
  has_many :markers
  has_many :shadow_scans
end
