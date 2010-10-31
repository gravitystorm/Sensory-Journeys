class Emotion < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id
  validates_associated :project
  
  validates_presence_of :text, :icon

  default_scope :order => :id
end
