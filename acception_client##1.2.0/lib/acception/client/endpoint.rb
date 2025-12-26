module Acception
  module Client
    class Endpoint

      include Endow::Endpoint

      def call
        set_content( synthesized_attributes )
        super
      end

    protected

      attr_reader :attributes

      def synthesized_attributes
        {
          application: application,
          comment: comment,
          environment: environment,
          message: message,
          message_type: message_type,
          occurred_at: occurred_at,
          path: path,
          request_headers: request_headers,
          request_parameters: request_parameters,
          stack: stack,
          session: session,
          type: type,
          variables: variables
        }.reject { |k,v| v.blank? }
      end

      def application
        application = attributes[:application] || Acception::Client::Configuration.application
        raise 'application must be provided or configured for acception error reporting' unless application
        application
      end

      def comment
        attributes[:comment]
      end

      def clean_text_for_request( text )
        text.gsub( /\n\ \ /, "\n" ).
             gsub( "`", "'" ).
             gsub( "'", "\"" )
      end

      def environment
        attributes[:environment]
      end

      def message
        attributes[:message]
      end

      def message_type
        message_type = attributes[:message_type]
        raise 'message_type is a required attribute' unless message_type
        Acception::MessageType.new( message_type ).key
      end

      def occurred_at
        occurred_at = attributes[:occurred_at]
        return nil unless occurred_at

        occurred_at.is_a?( String ) ?
          occurred_at :
          occurred_at.iso8601
      end

      def path
        attributes[:path]
      end

      def request_headers
        attributes[:request_headers]
      end

      def request_parameters
        attributes[:request_parameters]
      end

      def session
        attributes[:session]
      end

      def stack
        stack = attributes[:stack]
        return nil unless stack
        raise 'stack must be an Array' unless stack.is_a?( Array )

        clean_text_for_request( stack.join( "\n" ))
      end

      def type
        attributes[:type]
      end

      def variables
        attributes[:variables]
      end

      def retryable_times
        Acception::Client.configuration.retry_attempts
      end

      def retryable_sleep
        Acception::Client.configuration.retry_sleep
      end

      def open_timeout_in_seconds
        Acception::Client.configuration.open_timeout_in_seconds
      end

      def read_timeout_in_seconds
        Acception::Client.configuration.read_timeout_in_seconds
      end

      def default_headers
        {
          'Accept'                 => accept,
          'Content-Type'           => content_type,
          authentication_token_key => authentication_token
        }.reject { |k,v| v.blank? }
      end

      def accept
        'application/vnd.acception-v1+json'
      end

      def determine_accept_name
        matches = accept.match( /(.*)\/vnd\.(.*)-(v\d+)\+(.*)/ )
        [matches[1],
         matches[4]].join( '_' )
      end

      def content_type
        'application/json'
      end

      def response_wrapper_class
        Hashie::Mash
      end

      def authentication_token_key
        'Auth-Token'
      end

      def authentication_token
        Acception::Client.configuration.authentication_token
      end

      def base_url
        File.join( Acception::Client.configuration.base_url ,
                   'api' )
      end

      def ssl_verify_mode
        Acception::Client.configuration.ssl_verify_mode
      end

      def graceful_errors_map
        Acception::Client.configuration.graceful_errors_map
      end

    end
  end
end
