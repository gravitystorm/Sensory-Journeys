class SiteController < ApplicationController
  def index
    @schools = School.find(:all)
  end

end
