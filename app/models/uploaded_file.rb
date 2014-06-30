class UploadedFile < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, :polymorphic => true
  
  validates_presence_of :user, :resource, :title, :file
  
  has_attached_file :file
  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/
  
  def image?
    file_content_type.to_s.match(/\Aimage\/.*\Z/)
  end
end
