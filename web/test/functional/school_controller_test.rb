require 'test_helper'

class SchoolControllerTest < ActionController::TestCase

  fixtures :schools, :projects, :users

  def setup
    #@current_project = projects(:this)
    @user = users(:one)
    session[:admin] = true
    session[:user] = @user.id
  end

  def teardown
    #@current_project = nil
  end
  
  test "Can only remove current project stuff" do
    assert_equal 3, School.count
    get :delete, :school_id => schools(:this1).id
    assert_equal 2, School.count
    get :delete, :school_id => schools(:another1).id
    assert_equal 2, School.count
    assert_response :not_found
  end


end