class SchoolController < ApplicationController

  in_place_edit_for :school, :name
  in_place_edit_for :school, :lat
  in_place_edit_for :school, :lon

end