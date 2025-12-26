require 'cloudinary'
require 'yaml'

module Dragonfly
  class CloudinaryDatastore

    def write(content, opts={})
      result = Cloudinary::Uploader.upload(content.path, { tags: serialize_hash(content.meta) })
      "#{result['public_id']}.#{result['format']}"
    end

    def read(uid)
      resource = Cloudinary::Api.resource(File.basename(uid, File.extname(uid)))
      [Cloudinary::Downloader.download(uid), deserialize_to_hash(resource['tags'])]
    end

    def destroy(uid)
      Cloudinary::Uploader.destroy(uid)
    end

    private
    def serialize_hash(hash)
      return hash if hash.nil?
      hash.map { |k, v| "#{k}=>#{v}"}
    end

    def deserialize_to_hash(str_arr)
      return str_arr if str_arr.nil?
      res = str_arr.map { |x| x.split("=>") }.flatten
      hash = Hash[*res.flatten]
      hash
    end

  end
end
