class UploadedFilesController < ApplicationController
  layout 'file_browser'
  skip_before_filter :verify_authenticity_token, :only => :create

  # Will display all files in the given directory
  def index
    params[:path] = '.' if params[:path].blank?
    @path = Pathname.new params[:path]
    @current_directory = @path.basename.to_s
    @current_directory = 'Root Directory' if @current_directory == '.'

    pattern = "#{@path}/*"
    @directories = @storage.dirs pattern
    @uploaded_files = @storage.glob pattern
  end

  # Will stream a specific file out. This should only be used if
  # the file does not have a public_path.
  def show
    uploaded_file = @storage[Pathname.new params[:path]]
    if uploaded_file
      send_data uploaded_file.stream.read, :filename => uploaded_file.to_s
    else
      render :nothing => true, :status => :not_found
    end
  end

  # Will create a new entry in the given path. If the data is a string
  # then we assume a directory is being created. If the data is some
  # sort of IO object then we assume a file.
  def create
    params[:data] = params[:upload] if params.has_key? :upload # For CKEditor
    if params[:data].respond_to?(:read)
      filename = File.basename(params[:data].original_filename)
      filename = Pathname.new(params[:path] || '').join filename
      @storage[filename] = params[:data]
      @uploaded_file = @storage[filename]
    else
      path = Pathname.new(params[:path] || '').join params[:data]
      @storage.mkdir path
    end
    redirect_to :back unless params[:dropbox]
  end

  # Removes a specific file
  def destroy
    @storage.destroy params[:path]
    redirect_to :back
  end

  private

  def load_storage
    @storage = FileBrowser.storages[params[:storage].to_sym]
  end
  before_filter :load_storage
end
