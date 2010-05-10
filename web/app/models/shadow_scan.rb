class ShadowScan < ActiveRecord::Base
  belongs_to :school
  belongs_to :mode
  belongs_to :user
  
  # The shadow scans track the wpscans, but allow us to set
  # attributes without messing up walking papers. So each time the
  # system comes across a WPscan-id, it needs to be "claimed" as a 
  # ShadowScan
  
  # Oh how much easier it seems just to reimplement all of WP in rails :-)
end
