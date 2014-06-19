class UploadedFile < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, :polymorphic => true
  
  validates_presence_of :user, :resource, :title, :file
end
