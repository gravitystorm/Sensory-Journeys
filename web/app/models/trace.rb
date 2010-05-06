class Trace < ActiveRecord::Base
  require 'xml/libxml'
  include XML
  
  has_many :trace_points do
    def summary
      find(:all, :limit => MAX_TRACE_POINTS_SUMMARY, :order => :created_at)
    end
  end

  has_many :waypoints do
    def summary
      find(:all, :limit => MAX_WAYPOINTS_SUMMARY, :order => :created_at)
    end
  end
  
end
