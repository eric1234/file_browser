require 'test_helper'

class UploadedFilesControllerTest < ActionController::TestCase

  test 'root directory' do
    get :index, :path => [], :storage => 'local'

    assert_response :success
    assert_select 'h1', 'Root Directory'
    assert_select 'a', :text => /Return to/, :count => 0
    assert_select 'li', 4
    assert_select 'a[href=?]', '/local/uploaded_files/index/dir1'
    assert_select 'form[action=?]', '/local/uploaded_files/dir1'
    assert_select 'a[href=?]', '/local/uploaded_files/index/empty'
    assert_select 'form[action=?]', '/local/uploaded_files/empty'
    assert_select 'a[href=?]', '/local/uploaded_files/file1.txt'
    assert_select 'form[action=?]', '/local/uploaded_files/file1.txt'
    assert_select 'a[href=?]', '/local/uploaded_files/file2.txt'
    assert_select 'form[action=?]', '/local/uploaded_files/file2.txt'
  end

  test 'empty directory' do
    get :index, :path => ['empty'], :storage => 'local'

    assert_response :success
    assert_select 'h1', 'empty'
    assert_select 'a', /Return to Root Directory/
    assert_select 'li', 0
  end

  test 'subdirectory' do
    get :index, :path => ['dir1'], :storage => 'local'

    assert_response :success
    assert_select 'h1', 'dir1'
    assert_select 'a', /Return to Root Directory/
    assert_select 'li', 2
    assert_select 'a[href=?]', '/local/uploaded_files/index/dir1/subdir'
    assert_select 'form[action=?]', '/local/uploaded_files/dir1/subdir'
    assert_select 'a[href=?]', '/local/uploaded_files/dir1/subfile1.txt'
    assert_select 'form[action=?]', '/local/uploaded_files/dir1/subfile1.txt'
  end

  test 'sub of sub' do
    get :index, :path => ['dir1', 'subdir'], :storage => 'local'

    assert_response :success
    assert_select 'h1', 'subdir'
    assert_select 'a', /Return to dir1/
    assert_select 'li', 0
  end

  test 'show (root directory)' do
    get :show, :path => ['file1.txt'], :storage => 'local'

    assert_response :success
    assert_equal 'File 1', @response.body
  end

  test 'show (subdir)' do
    get :show, :path => ['dir1', 'subfile1.txt'], :storage => 'local'

    assert_response :success
    assert_equal 'File in subdirectory.', @response.body
  end

  test 'show (404)' do
    get :show, :path => ['foo.txt'], :storage => 'local'
    assert_response :not_found
  end

  test 'create folder (root directory)' do
    dest = storage_path.join 'foo'
    FileUtils.rmdir dest if dest.exist?
    assert !dest.exist?

    @request.env["HTTP_REFERER"] = '/local/uploaded_files/index'
    post :create, :path => [], :data => 'foo', :storage => 'local'

    assert dest.directory?
    FileUtils.rmdir dest if dest.exist?
  end

  test 'create folder (subdirectory)' do
    dest = storage_path.join 'dir1/foo'
    FileUtils.rmdir dest if dest.exist?
    assert !dest.exist?

    @request.env["HTTP_REFERER"] = '/local/uploaded_files/index/dir1'
    post :create, :path => ['dir1'], :data => 'foo', :storage => 'local'

    assert dest.directory?
    FileUtils.rmdir dest if dest.exist?
  end

  test 'create file (root directory)' do
    dest = storage_path.join 'foo.txt'
    FileUtils.rm dest if dest.exist?
    assert !dest.exist?

    @request.env["HTTP_REFERER"] = '/local/uploaded_files/index'
    file = StringIO.new('Test content')
    def file.original_filename; 'foo.txt' end
    post :create, :path => [], :data => file, :storage => 'local'

    assert dest.exist?
    FileUtils.rm dest if dest.exist?
  end

  test 'create file (subdirectory)' do
    dest = storage_path.join 'dir1/foo.txt'
    FileUtils.rm dest if dest.exist?
    assert !dest.exist?

    @request.env["HTTP_REFERER"] = '/local/uploaded_files/index/dir1'
    file = StringIO.new('Test content')
    def file.original_filename; 'foo.txt' end
    post :create, :path => ['dir1'], :data => file, :storage => 'local'

    assert dest.exist?
    FileUtils.rm dest if dest.exist?
  end

  test 'remove file (root directory)' do
    dest = storage_path.join 'foo.txt'
    File.open(dest, 'w+') {|f| f << 'Remove me'}
    assert dest.exist?

    @request.env["HTTP_REFERER"] = '/local/uploaded_files/index'
    delete :destroy, :path => ['foo.txt'], :storage => 'local'

    assert !dest.exist?
  end

  test 'remove file (sub-directory)' do
    dest = storage_path.join 'dir1/foo.txt'
    File.open(dest, 'w+') {|f| f << 'Remove me'}
    assert dest.exist?

    @request.env["HTTP_REFERER"] = '/local/uploaded_files/index/dir1'
    delete :destroy, :path => ['dir1', 'foo.txt'], :storage => 'local'

    assert !dest.exist?
  end

  test 'remove directory (root directory)' do
    dest = storage_path.join 'bar'
    dest.mkpath
    assert dest.directory?

    @request.env["HTTP_REFERER"] = '/local/uploaded_files/index'
    delete :destroy, :path => ['bar'], :storage => 'local'

    assert !dest.exist?
  end

  test 'remove directory (sub-directory)' do
    dest = storage_path.join 'dir1/bar'
    dest.mkpath
    assert dest.directory?

    @request.env["HTTP_REFERER"] = '/local/uploaded_files/index/dir1'
    delete :destroy, :path => ['dir1', 'bar'], :storage => 'local'

    assert !dest.exist?
  end

  def setup
    # Somehow this is getting cleared so reset it for testing
    FileBrowser.storages[:local] = FilesystemStorage.new storage_path
  end

  private

  def storage_path
    Pathname.new(__FILE__).dirname.join '../fixtures/fs_storage'
  end

end
