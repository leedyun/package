require "asset_uploader/version"

require 'digest/sha1'

class AssetUploader
 
  SIGNATURE_LENGTH = 6
  PADDING = "x" * SIGNATURE_LENGTH

  def initialize(prefix, path_to_asset)
    @prefix = prefix
    @path_to_asset = path_to_asset
    @original_file_name = @target_file_name = File.basename(@path_to_asset)
  end

  def sign
    content = File.read(@path_to_asset)
    digest  = Digest::SHA1.digest(content)
    digest  = digest.unpack("q").first
    digest  = -digest if digest < 0
    digest  =  "#{digest.to_s(36)}#{PADDING}"[0, SIGNATURE_LENGTH]
    @target_file_name = @original_file_name.sub(/\.(\w+)$/) { "__#{digest}__.#{$1}" }
  end

  def target_path
    File.join(@prefix, @target_file_name)
  end

  def upload
    require "asset_uploader/uploader"    # Defer because we don't need S3 keys just to sign
    uploader = Uploader.new
    path = uploader.do_upload(target_path, @path_to_asset)
    path.sub(/s3.amazonaws.com\//, '').sub(/\?AWS.*/, '').sub(/-origin/, '')
  end

end
