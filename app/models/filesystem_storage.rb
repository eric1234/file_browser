# A storage for file on the local filesystem under a specific path.
class FilesystemStorage

  # The root path of the current FileSystem storage
  attr_accessor :path

  # Creates a new storage located at the given path. If this path
  # happens to be publically available via HTTP you can provide that
  # path as well so that access the files does not have to go through
  # rails.
  def initialize(path, public_path=nil)
    @path = Pathname.new path
    @public_path = Pathname.new public_path if public_path
  end

  # Will retreive the UploadedFile object for the given key
  def [](key)
    path = @path.join key
    public_path = @public_path.join key if @public_path
    UploadedFile.new(key, nil, public_path) {File.open path} if path.file?
  end

  # Will store the given file under the given key. If the file responds
  # to :read then we assume a stream. Otherwise we convert to string and
  # assume a file path
  def []=(key, file)
    file = File.open(file.to_s) unless file.respond_to? :read
    path = @path.join key
    FileUtils.mkpath path.dirname
    File.open(path, 'wb') {|f| f << file.read}
    self[key]
  end

  # Like []= only creates a directory instead of a file. In stores
  # that don't really support directories it might need to create
  # a dummy hidden file to simulate a directory.
  def mkdir(path)
    path = @path.join path
    FileUtils.mkpath path
  end

  # Works like glob but will only return directories that match.
  #
  # Note that the storage device does not really need to support
  # directories. It could simulate it by quering the keys which is
  # why this is handled somewhat differently. It allows the backend
  # to optimize the directory pull (v.s. have the frontend query based
  # on keys which could be inefficient).
  def dirs(pattern)
    Pathname.glob(@path.join(pattern)).sort.collect do |match|
      path2key match if match.directory?
    end.compact
  end

  # Will file all UploadFile objects that match the given glob pattern
  def glob(pattern)
    Pathname.glob(@path.join(pattern)).sort.collect do |match|
      self[path2key match]
    end.compact
  end

  # Will remove a specific key from the database. Can point to an
  # UploadedFile or just a directory. If called on a file that does
  # not exist then this is a no-op.
  def destroy(key)
    path = @path.join key
    FileUtils.rm_rf path if path.exist?
  end

  private

  def path2key(path)
    path.to_s.sub(@path, '').sub /^\//, ''
  end
end