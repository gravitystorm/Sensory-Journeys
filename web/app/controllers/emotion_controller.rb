class EmotionController < ApplicationController

  before_filter :authorize
  before_filter :require_admin
  
  in_place_edit_for :emotion, :text
  in_place_edit_for :emotion, :icon

  def add
    e = @current_project.emotions.new
    e.text = params[:text]
    e.icon = params[:icon]
    e.save!

    flash[:notice] = "Added new emotion"
    redirect_to(:controller => :admin, :action => :emotions)
  end

  def delete
    e = @current_project.emotions.find_by_id(params[:emotion_id])
    if e
      if e.markers.count == 0
        e.destroy
        flash[:notice] = "Emotion deleted"
      else
        flash[:error] = "Emotion is used by markers"
      end
      redirect_to(:controller => :admin, :action => :emotions)
    else
      render :nothing => true, :status => :not_found
    end
  end

end