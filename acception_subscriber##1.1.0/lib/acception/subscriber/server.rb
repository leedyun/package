require 'bunny'
require 'celluloid'

module Acception
  module Subscriber
    class Server

      include ServerLogging
      include Logging

      attr_reader :message_consumer,
                  :options

      def initialize( options )
        @options = options

        configure_server
      end

      def start
        log_startup
        run

        trap( INT ) { finalize; exit }
        sleep
      end

    protected

      def finalize
        info "SHUTTING DOWN"
        message_consumer.cancel
        mq.close
      end

      def mq
        @mq ||= Bunny.new( host_uri ).tap do |bunny|
          bunny.start
        end
      end

      def channel
        @channel ||= mq.create_channel
      end

      def queue
        @queue ||= channel.queue( config.queue,
                                  durable: true )
      end

      def pool
        @pool ||= MessageHandler.pool( size: options[:threads] )
      end

      def run
        if options[:threads] == 1
          Celluloid::Actor[:message_handler] = MessageHandler.new
        end

        @message_consumer = queue.subscribe( manual_ack: true ) do |delivery_info, metadata, payload|
          debug ANSI.magenta { "LISTENER RECEIVED #{payload}" }

          if options[:threads] > 1
            pool.async.call( payload: payload,
                             delivery_info: delivery_info,
                             metadata: metadata,
                             channel: channel )
          else
            message_handler.call( payload: payload,
                                  delivery_info: delivery_info,
                                  metadata: metadata,
                                  channel: channel )
          end
        end
      end

      def message_handler
        Celluloid::Actor[:message_handler]
      end

      def host_uri
        config.host_uri
      end

      def config
        Acception::Subscriber.configuration
      end

      def configure_server
        load_configuration
        configure_acception
        initialize_loggers
      end

      def load_configuration
        if File.exists?( options[:config] )
          options[:config_loaded] = true
          Configuration.from_file( options[:config] )
        end
      end

      def configure_acception
        Acception::Client.configure do |c|
          c.authentication_token       = config.acception_auth_token
          c.base_url                   = config.acception_url
          #c.graceful_errors_map        = ServiceErrorHandling::GRACEFUL_ERRORS_MAP
          c.logger                     = Acception::Subscriber.logger
          #c.log_level                  = options.fetch( :log_level, :info ).to_sym
          c.open_timeout_in_seconds    = 10
          c.read_timeout_in_seconds    = 20
          #c.retry_attempts             = configatron.iols.retry_attempts.to_i || 1
          #c.retry_sleep                = configatron.iols.retry_sleep || false
        end
      end

    end
  end
end
