require 'test/unit'
require 'asset_uploader'
require 'flexmock/test_unit'

class TestAssetUploader < Test::Unit::TestCase

  def test_initial_state
    au = AssetUploader.new('prefix', 'myfile.jpg')
    assert_equal "prefix/myfile.jpg", au.target_path
  end

  def test_signing
    au = AssetUploader.new('prefix', 'myfile.jpg')
    flexmock(File).should_receive(:read).with('myfile.jpg').and_return('something')
    digest = 1234567890
    flexmock(Digest::SHA1).should_receive(:digest).and_return([digest].pack('q'))
    signed_path =  "myfile__#{digest.to_s(36)}__.jpg"
    assert_equal signed_path, au.sign
    assert_equal File.join('prefix', signed_path), au.target_path
  end

end