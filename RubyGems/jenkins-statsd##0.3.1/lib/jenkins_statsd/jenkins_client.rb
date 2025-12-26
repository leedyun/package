require 'json'
require 'rest-client'

module JenkinsStatsd
  class JenkinsClient
    attr_reader :metrics_url

    GAUGES_EXCLUDE = [
      %r{^jenkins\.versions}
    ]

    METERS_EXCLUDE = [
      %r{^http}
    ]

    TIMERS_EXCLUDE = [
      %r{^http},
      %r{^jenkins\.health},
      %r{^jenkins\.node}
    ]

    def initialize(host, api_token)
      @metrics_url = File.join(host, 'metrics', api_token, 'metrics')
    end

    def get_metrics
      metrics = {}
      response = RestClient.get metrics_url
      parsed = JSON.parse(response.body)
      metrics[:gauges] = extract_gauges(parsed)
      metrics[:meters] = extract_meters(parsed)
      metrics[:timers] = extract_timers(parsed)
      metrics
    end

    protected

    def ignore?(str, list)
      list.each do |pattern|
        return true if str.match(pattern)
      end
      false
    end

    def extract_gauges(data)
      gauges = {}
      data['gauges'].each do |key, value|
        next if ignore?(key, GAUGES_EXCLUDE)

        gauges[key] = value['value']
      end
      gauges
    end

    def extract_meters(data)
      meters = {}
      data['meters'].each do |key, components|
        next if ignore?(key, METERS_EXCLUDE)
        components.each do |component, value|
          next if component.match(%r{count|units})
          meters["#{key}.#{component}"] = value
        end
      end
      meters
    end

    def extract_timers(data)
      timers = {}
      data['timers'].each do |key, components|
        next if ignore?(key, TIMERS_EXCLUDE)
        components.each do |component, value|
          next unless component.match(%r{max|min|mean})
          timers["#{key}.#{component}"] = value
        end
      end
      timers
    end
  end
end
