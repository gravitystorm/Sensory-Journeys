class Wpscan < ActiveRecord::Base
  establish_connection :paperwalking

  set_table_name :scans
  
  def status
    case
    when self.last_step == 0 then "Uploading"
    when self.last_step == 1 then "Queued"
    when self.last_step == 2 then "Sifting"
    when self.last_step == 3 then "Finding Needles"
    when self.last_step == 4 then "Reading QR Code"
    when self.last_step == 5 then "Tiling"
    when self.last_step == 6 then "Finished"
    when self.last_step == 98 then "Bad QR Code"
    when self.last_step == 99 then "Error"
    when self.last_step == 100 then "Fatal Error"
    when self.last_step == 101 then "Fatal QR Code Error"
    else "Unknown Status"
    end
  end

  def bbox
    if self.print_id
      print = Wpprint.find(self.print_id)
      if print
        [print.west,print.south,print.east,print.north].join(",")
      end
    end
  end

  def large_png_url
    return WP_URL+'files/scans/'+self.id+'/large.png'
  end

  def preview_png_url
    return WP_URL+'files/scans/'+self.id+'/preview.png'
  end
end