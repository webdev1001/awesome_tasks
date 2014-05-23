class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, :polymorphic => true
  
  validates_presence_of :resource, :comment, :user
end
