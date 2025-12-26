require 'contributors_stats/base'
require 'contributors_stats/json_helper'

module ContributorsStats

  # Base for reading ContributorsStats data
  class Reader < Base
    include ContributorsStats::JsonHelper

    attr_reader :data, :raw_data

    def initialize(options = {})
      configure_path(*options.delete(:configure_path)) if options[:configure_path]
      super(options)
      @raw_data = []
      @data = nil
      parse_readers(filter_options("reader"))
    end

    # load data using given plugin
    # @param type [String] plugin to use
    # @param name [String] name to pass to the plugin
    def load(type, name)
      reader_plugin(type).load(name) do |data, name|
        log "repository: #{name}"
        @raw_data += data
      end
      @data = nil
    end

  private

    def reader_plugin(type)
      plugin = plugins.first_class!("reader", type)
      if plugin.kind_of?(ContributorsStats::JsonHelper)
        plugin.send(:configure_path, path_prefix, path_suffix)
      end
      plugin
    end

    def parse_readers(options = {})
      options.each do |type, name|
        if name.kind_of?(Array)
          name.each{|n| load(type,n)}
        else
          load(type, name)
        end
      end
    end

  end
end
