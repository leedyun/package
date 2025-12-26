require 'oj'

module Acception
  module Subscriber
    class Configuration

      def self.attributes
        %w(
          acception_auth_token
          acception_url
          host_uri
          queue
        )
      end

      attr_accessor( *attributes )

      def self.from_file( file_path )
        options = Oj.load( File.read( file_path ))
        Acception::Subscriber.configuration = Configuration.new

        attributes.each do |c|
          if options[c]
            Acception::Subscriber.configuration.send( :"#{c}=", options[c] )
          end
        end
      end

      def acception_auth_token
        @acception_auth_token
      end

      def acception_url
        @acception_url
      end

      def host_uri
        @host_uri || "amqp://guest:guest@127.0.0.1:5672"
      end

      def queue
        @queue || "error-repo"
      end

    end
  end
end
