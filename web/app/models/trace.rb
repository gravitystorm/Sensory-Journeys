class Trace < ActiveRecord::Base
  require 'xml/libxml'
  include XML
  
  has_many :trace_points, :order => :timestamp do
    def summary
      find(:all, :limit => MAX_TRACE_POINTS_SUMMARY)
    end
  end

  has_many :waypoints, :order => :timestamp do
    def summary
      find(:all, :limit => MAX_WAYPOINTS_SUMMARY)
    end
  end
  
end
