class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, :polymorphic => true
  
  validates_presence_of :resource, :comment, :user
  
  before_create :set_id_per_resource
  
private
  
  def set_id_per_resource
    previous_id = Comment.where(:resource => resource).order(:id_per_resource).last.try(:id_per_resource).to_i
    self.id_per_resource = previous_id + 1
  end
end
