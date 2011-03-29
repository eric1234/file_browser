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
    link_to label, path_to_uploaded_file(file)
  end

  def path_to_uploaded_file(file)
    if file.public_path
      if FileBrowser.resize && defined?(AssetProcess) && (file.general_type == 'image')
        file.public_path.to_s + '.resized/' + FileBrowser.resize
      else
        file.public_path
      end
    else
      uploaded_file_path :path => to_parts(file.path)
    end.to_s
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

  def icon_for(file)
    if defined?(AssetProcess) && file.public_path && (file.general_type == 'image')
      file.public_path.to_s + '.resized/pad/128x128'
    else
      "file_browser/#{file.general_type}.png"
    end
  end

end
