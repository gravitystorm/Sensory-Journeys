class ScanController < ApplicationController

  before_filter :authorize
  before_filter :require_user

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

      ss = @current_project.shadow_scans.new
      ss.scan_id = scan_id
      ss.user_id = @user.id
      ss.save

      wpscan = Wpscan.new
      wpscan.id = scan_id
      wpscan.user_id = 'pholder1'
      wpscan.created = Time.now
      wpscan.is_private = 'no'
      wpscan.will_edit = 'yes'
      wpscan.save

      set_step(wpscan,0)

      content = WP_URL+'files/scans/'+scan_id+'/'+filename
      add_message(content)

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

  def set_step(wpscan, number)
    # this dreadful code is a result of a combination of a lack of primary key on the steps table in WP and the postgres plugin using RETURNING pk
    # If anyone has any bright ideas I'm all ears.
    #sql = ActiveRecord::Base.connection();
    #sql.execute("INSERT INTO \"steps\" (\"number\", \"user_id\", \"scan_id\", \"created\") VALUES(#{number}, 'pholder1', '#{wpscan.id}', now)")
    wps = Wpstep.new
    wps.set_step(wpscan, number)

    wpscan.last_step = number
    wpscan.save
  end

  def add_message(content)
    message = Wpmessage.new
    message.created = Time.now
    message.available = Time.now
    message.content = content
    message.save
  end
end
