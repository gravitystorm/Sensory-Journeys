class User < ActiveRecord::Base
  has_many :traces
  has_many :markers
end
