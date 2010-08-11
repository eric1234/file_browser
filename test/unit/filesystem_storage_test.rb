require 'test_helper'

class FilesystemStorageTest < ActiveSupport::TestCase

  test 'retrieval' do
    assert_nil storage['foo']
    assert_nil storage['dir1']
    assert_kind_of UploadedFile, storage['file1.txt']
    assert_equal 'file1.txt', storage['file1.txt'].path.to_s
    assert_equal 'File 1', storage['file1.txt'].stream.read
    assert_kind_of UploadedFile, storage['dir1/subfile1.txt']
    assert_equal 'dir1/subfile1.txt', storage['dir1/subfile1.txt'].path.to_s
    assert_equal 'File in subdirectory.',
      storage['dir1/subfile1.txt'].stream.read
  end

  test 'store by name' do
    dest = storage_path.join 'inserted_file.txt'
    FileUtils.rm dest if dest.exist?
    assert !dest.exist?

    storage['inserted_file.txt'] =
      Pathname.new(__FILE__).dirname.join '../fixtures/new_file.txt'

    assert_equal 'A new file', File.open(dest).read
    FileUtils.rm dest if dest.exist?
  end

  test 'store by name (subdir)' do
    dest = storage_path.join 'temp/inserted_file.txt'
    FileUtils.rm_rf dest.dirname if dest.dirname.exist?
    assert !dest.dirname.exist?

    storage['temp/inserted_file.txt'] =
      Pathname.new(__FILE__).dirname.join '../fixtures/new_file.txt'

    assert_equal 'A new file', File.open(dest).read
    FileUtils.rm_rf dest.dirname if dest.exist?
  end

  test 'store by io' do
    dest = storage_path.join 'inserted_io.txt'
    FileUtils.rm dest if dest.exist?
    assert !dest.exist?

    storage['inserted_io.txt'] = StringIO.new 'IO stream'

    assert_equal 'IO stream', File.open(dest).read
    FileUtils.rm dest if dest.exist?
  end

  test 'mkdir' do
    dest = storage_path.join 'foo'
    FileUtils.rmdir dest if dest.exist?
    assert !dest.exist?

    storage.mkdir 'foo'
    assert dest.directory?
    FileUtils.rmdir dest if dest.exist?
  end

  test 'dirs' do
    results = storage.dirs('*')
    assert_equal ['dir1', 'empty'], results.collect(&:to_s)
  end

  test 'glob' do
    results = storage.glob('*')
    results.each {|r| assert_kind_of UploadedFile, r}
    assert_equal 'file1.txt', results[0].path.to_s
    assert_equal 'File 1', results[0].stream.read
    assert_equal 'file2.txt', results[1].path.to_s
    assert_equal 'Another file', results[1].stream.read
  end

  test 'destroy' do
    storage['remove-me.txt'] = StringIO.new 'Remove Me'
    assert storage_path.join('remove-me.txt').exist?

    storage.destroy 'remove-me.txt'

    assert !storage_path.join('remove-me.txt').exist?
  end

  private

  def storage
    return @storage if @storage 
    @storage = FilesystemStorage.new storage_path
  end

  def storage_path
    Pathname.new(__FILE__).dirname.join '../fixtures/fs_storage'
  end

end