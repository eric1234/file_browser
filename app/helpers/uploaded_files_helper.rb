module UploadedFilesHelper

  def link_to_up(label='..', path=@path)
    return if path.to_s == '.'

    name = path.dirname
    name = 'Root Directory' if name.to_s == '.'
    label = label.sub '?', name
    link_to_directory path.dirname, label, :id => 'up-dir'
  end

  def link_to_directory(dir, label=File.basename(dir), options={})
    path = params.merge({
      :controller => 'uploaded_files',
      :action => 'index',
      :path => to_parts(dir),
      :integration => params[:integration]
    })
    link_to label, path, options
  end

  def link_to_uploaded_file(file, label=file.to_s)
    url = file.public_path || uploaded_file_path(:path => to_parts(file.path))
    link_to label, url.to_s
  end

  def uploaded_file_form_tag(&blk)
    path = create_uploaded_file_path :path => to_parts(@path)
    form_tag path, :multipart => true, &blk
  end

  def link_to_destroy(path, label='X')
    button_to label, delete_uploaded_file_path(:path => to_parts(path)), :method => :delete
  end

  def to_parts(path)
    path.to_s.split('/').reject &:blank?
  end

end