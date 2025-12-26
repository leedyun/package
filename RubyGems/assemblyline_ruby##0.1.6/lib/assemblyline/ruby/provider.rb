require "assemblyline/ruby/platform"

module Assemblyline
  module Ruby
    module Provider
      extend self

      def provider
        platform = Platform.new
        load_provider(platform.id)
      rescue NameError, LoadError => e
        begin
          return load_provider(platform.like) if platform.like
          fail e
        rescue NameError, LoadError
          raise "Platform: #{platform.id} not supported"
        end
      end

      def load_provider(name)
        require "assemblyline/ruby/provider/#{name}"
        const_get(name.capitalize).new
      end
    end
  end
end
