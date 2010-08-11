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

end