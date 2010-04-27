class Wpscan < ActiveRecord::Base
  establish_connection :paperwalking

  set_table_name :scans
end