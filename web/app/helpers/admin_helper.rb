module AdminHelper

  def is_reviewer
    return @user && session[:reviewer] == true
  end

  def is_admin
    return @user && session[:admin] == true
  end

end
