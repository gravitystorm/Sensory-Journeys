class ScanController < ApplicationController

  # The Scan controller is a reimplementation of WP uploading in rails. This allows us access to
  # @current_project and saves faffing around with the PHP code (as well as fixing the issues with form timeouts etc
  # that exist in the WP code
  # Storing modes, aliases and suchlike is still done by the shadow_scan controller, for now, but these could potentially be combined
  # at some point in the future.

  def upload
  end

  def uploadFile
    if params[:upload]
      scan = params[:upload]['scan']

      filename = File.basename(scan.original_filename)
      scans_path = RAILS_ROOT + '/../wp/site/www/files/scans/'
      scan_id = generate_id

      File.umask(0)
      #TODO
      #unless os.exists(scans_path)
        #Dir.mkdir(blah)
      #end

      Dir.mkdir(scans_path+scan_id, 0777)

      f = File.open(scans_path+scan_id+'/'+filename, 'w', 0666)
      f.syswrite(scan.read)
      f.close

      redirect_to :action => :scan, :scan_id => scan_id
    else
      flash[:error] = "No file uploaded"
      redirect_to :action => :upload
    end
  end

  def scan
  end

  def generate_id
    chars = 'qwrtpsdfghklzxcvbnm23456789'
    id = ''

    8.times {id << chars[rand(chars.length)]}

    return id
  end

end
