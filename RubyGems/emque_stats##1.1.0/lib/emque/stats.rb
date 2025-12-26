require "emque/stats/version"
require "emque/stats/configuration"
require "emque/stats/client"

module Emque
  module Stats
    class << self
      attr_accessor :client
      attr_writer :configuration

      def logger
        self.configuration.logger
      end

      def configure
        yield(configuration)
        self.client = Client.new(configuration)
      end

      def configuration
        @configuration ||= Configuration.new
      end

      def track(event_name, props = {})
        Emque::Stats.client.produce_track_event(event_name, props)
      end

      def increment(event_name)
        count(event_name, 1)
      end

      def count(event_name, count=1)
        Emque::Stats.client.produce_count(event_name, count)
      end

      def timer(event_name, duration)
        Emque::Stats.client.produce_timer(event_name, duration)
      end

      def gauge(event_name, value)
        Emque::Stats.client.produce_gauge(event_name, value)
      end
    end
  end
end
