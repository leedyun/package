require 'endow'

module Acception
  module Client
    class Configuration

      attr_accessor :application

      def authentication_token
        raise 'authentication_token configuration missing' unless @authentication_token
        @authentication_token
      end

      def authentication_token=( authentication_token )
        @authentication_token = authentication_token
      end

      def base_url
        raise 'base_url configuration missing' unless @base_url
        @base_url
      end

      def base_url=( base_url )
        @base_url = base_url
      end

      def graceful_errors_map
        @graceful_errors_map ||= {}
      end

      def graceful_errors_map=( map )
        @graceful_errors_map = map
      end

      def logger
        @logger
      end

      def logger=( logger )
        @logger = logger
        Endow.configure { |c| c.logger = logger }
      end

      def open_timeout_in_seconds
        @open_timeout_in_seconds ||= 10
      end

      def open_timeout_in_seconds=( open_timeout_in_seconds )
        @open_timeout_in_seconds = open_timeout_in_seconds
      end

      def read_timeout_in_seconds
        @read_timeout_in_seconds ||= 10
      end

      def read_timeout_in_seconds=( read_timeout_in_seconds )
        @read_timeout_in_seconds = read_timeout_in_seconds
      end

      def retry_sleep
        @retry_sleep ||= false
      end

      def retry_sleep=( retry_sleep )
        @retry_sleep = retry_sleep
      end

      def retry_attempts
        @retry_attempts ||= 0
      end

      def retry_attempts=( retry_attempts )
        @retry_attempts = retry_attempts
      end

      def ssl_verify_mode
        @ssl_verify_mode ||= :none # one of [:none, :peer, :fail_if_no_peer_cert, :client_once]
      end

      def ssl_verify_mode=( ssl_verify_mode )
        @ssl_verify_mode = ssl_verify_mode
      end

    end
  end
end
