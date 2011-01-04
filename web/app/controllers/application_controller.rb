# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_current_project
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
      begin
        @user = User.find(session[:user])
      rescue ActiveRecord::RecordNotFound
        @user = nil
        session[:user] = nil
      end
    else
      @user = nil
    end
  end
  
  def require_user
    unless @user
      flash[:error] = "You aren't logged in"
      redirect_to :controller => :site, :action => :index
    end
  end
  
  def require_admin
    unless @user && session[:admin] == true
      flash[:error] = "You can't access that page"
      redirect_to :controller => :site, :action => :index
    end
  end
  
  def assert_method(method)
    ok = request.send((method.to_s.downcase + "?").to_sym)
    raise NotThatMethodError unless ok
  end

  private
    def set_current_project
      # Find the project settings using the PROJECT_ID environment variable, set by e.g. apache site configs.
      # For more flexibility this could be done via pattern matching against domain names, and there are appropriate
      # columns in the projects table to support this, e.g.
      # @current_project = Project.find_by_subdomain(request.subdomains.last)

      id = ENV['PROJECT_ID'].to_i
      if (!id || id == 0)
        id = 1
      end
      @current_project = Project.find(id)
    end
  
  class NotThatMethodError < RuntimeError
    def status
      :method_not_allowed
    end
    
    def to_s
      "Oi! Stop poking around the website."
    end
  end
end
