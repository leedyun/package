require "cocoapods/fixbugs/plugin/version"

module Pod
  class Sandbox
    class FileAccessor
      # @param  [Pathname] framework
      #         The vendored framework to search into.
      # @return [Pathname] The path of the header directory of the
      #         vendored framework.
      #
      def self.vendored_frameworks_headers_dir(framework)
        headers_dir = framework + 'Headers'
        if headers_dir.exist?
          headers_dir.realpath
        else
          headers_dir
        end
      end
    end
  end
end