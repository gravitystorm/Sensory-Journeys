class Trace < ActiveRecord::Base
  require 'xml/libxml'
  include XML
  
  belongs_to :school
  belongs_to :mode
  
  has_many :trace_points, :dependent => :destroy, :order => :timestamp do
    def summary
      find(:all, :limit => Settings.max_trace_points_summary.to_i)
    end
  end

  has_many :waypoints, :dependent => :destroy, :order => :timestamp do
    def summary
      find(:all, :limit => Settings.max_waypoints_summary.to_i)
    end
  end
  
end
