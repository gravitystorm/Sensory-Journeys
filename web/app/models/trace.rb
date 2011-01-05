class Trace < ActiveRecord::Base
  require 'xml/libxml'
  include XML
  
  belongs_to :school
  belongs_to :mode

  belongs_to :project

  validates_presence_of :project_id
  validates_associated :project
  
  has_many :trace_points, :dependent => :destroy, :order => :timestamp do
    def summary(limit)
      find(:all, :limit => limit)
    end
  end

  has_many :waypoints, :dependent => :destroy, :order => :timestamp do
    def summary(limit)
      find(:all, :limit => limit)
    end
  end
  
end
