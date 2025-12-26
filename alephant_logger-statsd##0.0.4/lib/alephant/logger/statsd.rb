require "statsd-ruby"
require "thread"

module Alephant
  module Logger
    class Statsd
      def initialize(config = {})
        @server = connect defaults.merge(config)
      end

      def increment(key, interval = 1)
        send_data { server.increment(key, interval) }
      end

      alias metric increment

      def timing(key, milliseconds, sample_rate = 1)
        send_data { server.timing(key, milliseconds, sample_rate) }
      end

      private

      attr_reader :server

      def connect(config)
        ::Statsd.new(config[:host], config[:port]).tap do |s|
          s.namespace = config[:namespace]
        end
      end

      def defaults
        {
          :host      => "localhost",
          :port      => 8125,
          :namespace => "statsd"
        }
      end

      def send_data
        Thread.new { yield }
      end
    end
  end
end
