class Wpmessage < ActiveRecord::Base
  establish_connection :paperwalking

  set_table_name :messages

end