require "assemblyline/ruby/provider"
require "assemblyline/ruby/system_packages"

module Assemblyline
  module Ruby
    class Installer
      def initialize(provider = nil)
        @provider = provider || Provider.provider
      end

      def install
        provider.install
        yield
        provider.remove
      end

      private

      attr_reader :provider
    end
  end
end
