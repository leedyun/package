require 'celluloid/autostart'
require 'oj'

module Acception
  module Subscriber
    class MessageHandler

      include Celluloid
      include Logging

      BLANK             = '<<blank>>'
      ERROR             = 'error'
      LICENSE_VIOLATION = 'license-violation'
      REQUEUE           = true

      def call( options )
        channel       = options[:channel]
        delivery_info = options[:delivery_info]
        payload       = options[:payload]
        metadata      = options[:metadata]
        headers       = metadata[:headers]

        debug ANSI.cyan { 'HEADERS' } + " #{headers}"
        debug ANSI.yellow { 'PAYLOAD' } + " #{payload}"

        case resolve_type( payload )
          when ERROR
            handle_error( headers )
          when LICENSE_VIOLATION
            handle_license_violation( headers )
          else
        end

        channel.acknowledge( delivery_info.delivery_tag )
      rescue => e
        debug ANSI.red { "ERROR" } + " #{e.message}"
        debug ANSI.red { "ERROR" } + " #{e.backtrace}"
        channel.nack delivery_info.delivery_tag
      end

    protected

      def handle_error( headers )
        exception = headers['exception']
        acception = Acception::Client::OpenMessages::Create.new( message_type: Acception::MessageType::ERROR,
                                                                 application: (headers['application'] || BLANK),
                                                                 environment: (headers['environment'] || BLANK),
                                                                 occurred_at: (headers['occurred_at'] || BLANK),
                                                                 message: (exception['message'] || BLANK),
                                                                 request_headers: (headers['request_headers'] || BLANK),
                                                                 request_parameters: (headers['request_parameters'] || BLANK),
                                                                 session: (headers['session'] || BLANK),
                                                                 type: (exception['class'] || BLANK),
                                                                 stack: (exception['backtrace'] || BLANK) )
        # TODO handle failure as well as success
        acception.call
      end

      def handle_license_violation( headers )
        acception = Acception::Client::OpenMessages::Create.new( message_type: Acception::MessageType::LICENSE_VIOLATION,
                                                                 application: headers['application'],
                                                                 occurred_at: headers['occurred_at'],
                                                                 variables: [
                                                                   {
                                                                     name: 'license-violation-type',
                                                                     content: (headers['type'] || BLANK),
                                                                     content_type: 'text/plain'
                                                                   },
                                                                   {
                                                                     name: 'exceeded_days',
                                                                     content: (headers['exceeded_days'] || BLANK),
                                                                     content_type: 'text/plain'
                                                                   },
                                                                   {
                                                                     name: 'license-content',
                                                                     content: (headers['content'] || BLANK),
                                                                     content_type: 'application/base64'
                                                                   },
                                                                   {
                                                                     name: 'nonce',
                                                                     content: (headers['nonce'] || BLANK),
                                                                     content_type: 'application/base64'
                                                                   },
                                                                   {
                                                                     name: 'site-private-key',
                                                                     content: (headers['site_private_key'] || BLANK),
                                                                     content_type: 'application/base64'
                                                                   },
                                                                   {
                                                                     name: 'iberon-public-key',
                                                                     content: (headers['iberon_public_key'] || BLANK),
                                                                     content_type: 'application/base64'
                                                                   }
                                                                 ])
        # TODO handle failure as well as success
        acception.call
      end

      def resolve_type( payload )
        return ERROR             if payload == ERROR
        return LICENSE_VIOLATION if payload == LICENSE_VIOLATION
        return nil
      end

      def config
        Acception::Subscriber.configuration
      end

    end
  end
end
