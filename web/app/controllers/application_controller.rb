# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '25dd5baaf90b46c7f92d6bd6f752dae6'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def authorize
    if session[:user]
      @user = User.find(session[:user])
    else
      @user = nil
    end
  end
  
  def require_user
    unless @user
      flash[:notice] = "You aren't logged in"
      redirect_to :controller => :site, :action => :index
    end
  end
end
