require 'test_helper'

class SchoolTest < ActiveSupport::TestCase

  fixtures :schools, :projects
  
  def test_fixtures
    assert_equal 2, School.count
  end

  test "should not save school without lat/lon" do
    school = School.new(:project => Project.find(:first))
    assert !school.save, "Saved the school without lat/lon"
    school.lat = "51.2"
    assert !school.save, "Saved the school with only lat"
    school.lon = "0.2"
    assert school.save
  end

  test "should not save school without project" do
    school = School.new(:lat => "40", :lon => "45")
    assert !school.save, "Saved school without project"
    school.project = Project.find(:first)
    assert school.save
  end
end
