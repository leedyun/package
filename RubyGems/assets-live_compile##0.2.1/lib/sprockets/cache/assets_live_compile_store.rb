require 'sprockets/cache/file_store'

module Sprockets
  class Cache
    class AssetsLiveCompileStore < FileStore

      def initialize options = {}
        super "#{::Rails.root}/tmp/cache"
        @assets_path = "#{::Rails.root}/public/assets"
      end

      def set key, attrs
        super
        return attrs unless ::Rails.application.config.assets.digest
        return attrs unless attrs.is_a? Hash and (logical_path = attrs[:logical_path]).present?
        return attrs if logical_path.index '.self.' and not ::Rails.application.config.assets.debug

        asset = Sprockets::Asset.new nil, attrs
        path = File.join @assets_path, asset.digest_path.strip
        FileUtils.mkdir_p File.dirname(path)
        File.open(path, 'wb'){ |f| f.write asset.source }

        attrs
      end

    end
  end
end
