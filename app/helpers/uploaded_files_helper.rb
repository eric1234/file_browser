module UploadedFilesHelper

  def link_to_up(label='..', path=@path)
    return if path.to_s == '.'

    name = path.dirname
    name = 'Root Directory' if name.to_s == '.'
    label = label.sub '?', name
    link_to_directory path.dirname, label.html_safe, :id => 'up-dir'
  end

  def link_to_directory(dir, label=File.basename(dir), options={})
    path = params.merge({
      :controller => 'uploaded_files',
      :action => 'index',
      :path => dir,
      :integration => params[:integration]
    })
    link_to label, path, options
  end

  def link_to_uploaded_file(file, label=file.to_s)
    link_to label, path_to_uploaded_file(file)
  end

  def path_to_uploaded_file(file)
    if FileBrowser.resize && defined?(Dragonfly) && (file.general_type == 'image')
      resized_uploaded_file_path :path => file.path, :size => FileBrowser.resize
    else
      if file.public_path
        file.public_path
      else
        uploaded_file_path :path => file.path
      end
    end.to_s
  end

  def uploaded_file_form_tag(&blk)
    path = create_uploaded_file_path :path => @path
    form_tag path, :multipart => true, &blk
  end

  def link_to_destroy(path, label='X')
    button_to label, delete_uploaded_file_path(:path => path), :method => :delete
  end

  def icon_for(file)
    if defined?(Dragonfly) && (file.general_type == 'image')
      resized_uploaded_file_path :path => file.path, :size => '128x128'
    else
      "file_browser/#{file.general_type}.png"
    end
  end

end
