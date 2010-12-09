require 'test_helper'

class UploadedFileTest < ActiveSupport::TestCase

  test 'initialization and accessors' do
    uf = UploadedFile.new('/bar/foo.txt', 'text/plain', '/uploaded_files/bar/foo.txt') {StringIO.new "Bar"}
    assert_equal '/bar/foo.txt', uf.path
    assert_equal '/uploaded_files/bar/foo.txt', uf.public_path
    assert_equal 'Bar', uf.stream.read
    assert_equal 'text/plain', uf.mime_type
    assert_equal 'txt', uf.extension
    assert_equal 'foo.txt', uf.to_s
  end

  test 'no extension' do
    uf = UploadedFile.new 'foo'
    assert_nil uf.extension
  end

  test 'general_type' do
    assert_equal 'compressed', UploadedFile.new('test.fake', 'application/zip').general_type
    assert_equal 'compressed', UploadedFile.new('test.zip', 'application/octet-stream').general_type
    assert_equal 'unknown', UploadedFile.new('test.fake', 'application/fake').general_type
  end

end
