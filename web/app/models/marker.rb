class Marker < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id
  validates_associated :project

  validates_presence_of :lat, :lon
end
