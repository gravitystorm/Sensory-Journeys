class EmotionController < ApplicationController

  before_filter :authorize
  before_filter :require_admin
  
  in_place_edit_for :emotion, :text
  in_place_edit_for :emotion, :icon

end