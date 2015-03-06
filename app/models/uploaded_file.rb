class UploadedFile < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, polymorphic: true

  validates_presence_of :user, :resource, :title, :file

  has_attached_file :file
  validates_attachment_content_type :file, content_type: /\A(image\/.*|((application|text)\/(x-extension-eml|html|plain|pdf|zip|x-zip|x-zip-compressed)))\Z/

  before_validation :set_title_to_filename_if_blank

  def image?
    file_content_type.to_s.match(/\Aimage\/.*\Z/)
  end

private

  def set_title_to_filename_if_blank
    extname = File.extname(file_file_name)
    self.title = File.basename(file_file_name, extname).gsub(/_+/, " ") if title.blank? && file_file_name.present?
  end
end
