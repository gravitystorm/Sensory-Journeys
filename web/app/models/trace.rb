class Trace < ActiveRecord::Base
  require 'xml/libxml'
  include XML
  
  belongs_to :school
  belongs_to :mode
  
  has_many :trace_points, :dependent => :destroy, :order => :timestamp do
    def summary
      find(:all, :limit => MAX_TRACE_POINTS_SUMMARY)
    end
  end

  has_many :waypoints, :dependent => :destroy, :order => :timestamp do
    def summary
      find(:all, :limit => MAX_WAYPOINTS_SUMMARY)
    end
  end
  
end
