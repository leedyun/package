# Emulates a source to ensure it has methods [#read] and [#path]
class ABBYY::Cloud
  module Operations
    class File
      extend Dry::Initializer::Mixin
      param  :source
      option :content_type

      def read
        source.respond_to?(:read) ? source.read : source
      end

      def path
        @path ||= \
          if source.respond_to?(:path)
            Pathname.new(source.path).basename
          else
            "#{SecureRandom.hex(4)}.#{ext}"
          end
      end

      private

      def ext
        MIME::Types[content_type].first.preferred_extension
      end
    end
  end
end
