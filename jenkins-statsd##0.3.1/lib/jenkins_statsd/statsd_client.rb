require 'statsd-ruby'

module JenkinsStatsd
  class StatsdClient
    attr_reader :statsd
    def initialize(host, port, namespace)
      @statsd = Statsd.new(host, port).tap { |sd| sd.namespace = namespace }
    end

    def send_metrics(metrics)
      metrics[:gauges].each do |key, value|
        statsd.gauge(key, value)
      end

      metrics[:meters].each do |key, value|
        statsd.gauge(key, value)
      end

      metrics[:timers].each do |key, value|
        statsd.gauge(key, value)
      end
    end
  end
end
