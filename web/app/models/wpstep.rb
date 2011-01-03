class Wpstep < ActiveRecord::Base
  establish_connection :paperwalking

  set_table_name :steps

  def set_step(wpscan, number)
    # this dreadful code is a result of a combination of a lack of primary key on the steps table in WP and the postgres plugin using RETURNING pk
    # If anyone has any bright ideas I'm all ears.
    conn = connection()
    conn.execute("INSERT INTO \"steps\" (\"number\", \"user_id\", \"scan_id\", \"created\") VALUES(#{number}, 'pholder1', '#{wpscan.id}', now())")
  end
end