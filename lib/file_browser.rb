module FileBrowser

  # Stores all configured storages for the current app. The application
  # should configure this similar to:
  #
  # FileBrowser.storages[:local] = FilesystemStorage.new('/path/to/root')
  #
  # When the browser is loaded it will have the key as the prefix. So
  # for example:
  #
  #   /local/uploaded_files
  #
  # Will pull the UploadedFilesController::index action using the :local
  # key set above.
  mattr_accessor :storages
  self.storages = {}

  # If set to true then the file browser provides no way to create
  # directories or add files. So you can only select files. You can
  # still add files via the drop functionality. This is not a security
  # issue but just simplifying the interface so the file browser is
  # as simple as possible.
  mattr_accessor :select_only
  self.select_only = false

  mattr_accessor :resize

  class Engine < Rails::Engine
    config.assets.precompile += %w(file_browser.js file_browser.css)
  end

end
