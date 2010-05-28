class Wpprint < ActiveRecord::Base
  establish_connection :paperwalking

  set_table_name :prints
end
  