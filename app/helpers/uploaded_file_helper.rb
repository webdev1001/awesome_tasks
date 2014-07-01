module UploadedFileHelper
  def link_to_uploaded_file(uploaded_file, args = {})
    if args[:title].present?
      title = args[:title]
    elsif uploaded_file.title.present?
      title = uploaded_file.title
    elsif uploaded_file.file_file_name.present?
      title = uploaded_file.file_file_name
    else
      title = _("File %{id}", :id => uploaded_file.id)
    end
    
    return link_to title, uploaded_file
  end
end
