class Marker < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id
  validates_associated :project

  validates_presence_of :lat, :lon

  belongs_to :emotion

  default_scope :order => :id

  def emotion_text
    emotion.text
  end
end
