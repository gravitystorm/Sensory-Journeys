class Trace < ActiveRecord::Base
  require 'xml/libxml'
  include XML
  
  has_many :trace_points, :order => :timestamp do
    def summary
      find(:all, :limit => MAX_TRACE_POINTS_SUMMARY, :order => :timestamp)
    end
  end

  has_many :waypoints, :order => :timestamp do
    def summary
      find(:all, :limit => MAX_WAYPOINTS_SUMMARY, :order => :timestamp)
    end
  end
  
end
