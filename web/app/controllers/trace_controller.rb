class TraceController < ApplicationController
  def index
    @traces = Trace.find(:all)
  end
  
  def upload
  end
  
  def uploadFile
    flash[:notice] = "Not implemented"
    redirect_to(:action => :upload)
  end
end
