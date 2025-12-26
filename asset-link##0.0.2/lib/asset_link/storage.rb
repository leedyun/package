require 'fog'

module AssetLink
  class Storage

    class BucketNotFound < StandardError; end

    attr_accessor :config

    def initialize(cfg)
      @config = cfg
    end

    def connection
      @connection ||= Fog::Storage.new(config.fog_options)
    end

    def bucket
      @bucket ||= begin
        bucket = connection.directories.get(config.fog_directory)
        bucket = connection.directories.create(key: config.fog_directory) unless bucket
        bucket
      end
    end

  end
end
