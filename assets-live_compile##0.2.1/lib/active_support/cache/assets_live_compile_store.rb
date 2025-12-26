require 'active_support/cache/file_store'

module ActiveSupport
  module Cache
    class AssetsLiveCompileStore < FileStore

      StaticAssetsPath = "#{Rails.root}/public/assets"

      def initialize options = {}
        super "#{StaticAssetsPath}/cache", options
      end

      def assets_config
        Rails.application.config.assets
      end

      private

      def write_entry key, entry, options
        super
        source = entry.original_value['source']
        digest = entry.original_value['digest']
        logical_path = entry.original_value['logical_path']
        if assets_config.digest
          ext = File.extname logical_path
          logical_path = logical_path.gsub(/#{ext}$/, "-#{digest}#{ext}")
        end

        path = File.join StaticAssetsPath, logical_path
        FileUtils.mkdir_p File.dirname(path)
        File.atomic_write(path, cache_path) {|f| f.write source }
      end

    end
  end
end

