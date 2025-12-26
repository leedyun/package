require 'statsd'

require "education_stats/version"
require "education_stats/client"

module EducationStats
  HOSTED_GRAPHITE_HOST = 'statsd.hostedgraphite.com'.freeze
  HOSTED_GRAPHITE_PORT = 8125.freeze

  class << self
    attr_accessor :hosted_graphite_api_key, :hosted_graphite_namespace
    attr_writer   :use_hosted_graphite

    # Public: Configuration for EducationStats
    #
    # Example
    #
    #   EducationStats.configure do |config|
    #     config.hosted_graphite_api_key = 'abc123'
    #   end
    #
    # Yields self for configuring options
    def configure
      yield self
    end

    # Public: Get the configured EducationStats client. This acts as a single
    # Statd client, but will forward all commands to the internal clients.
    #
    # Example
    #
    #   client = EducationStats.client
    #   client.increment 'education.mymetric'
    #
    # Returns a configured instance of EducationStats::Client
    def client
      EducationStats::Client.new(all_clients)
    end

    # Public: Add an instance of Statsd::Client to report to.
    def add_statsd_client(statsd_client)
      statsd_clients << statsd_client
    end

    # Public: Get all the configured Statsd clients that will be reported to.
    #
    # Returns an array of Statsd client classes
    def all_clients
      @all_clients ||= if use_hosted_graphite
        statsd_clients.push(build_hosted_graphite_statsd_client)
      else
        statsd_clients
      end
    end

    # Public: should EducationStats use a HostedGraphite Statsd
    #
    # Returns a Boolean
    def use_hosted_graphite
      @use_hosted_graphite ||= !!hosted_graphite_api_key
    end

    # Public: returns EducationStats to its original unconfigured state
    #
    # Returns an unconfigured EducationStats class
    def reset
      @hosted_graphite_api_key = nil
      @hosted_graphite_namespace = nil
      @use_hosted_graphite = nil
      @all_clients = nil
      @statsd_clients = nil
      self
    end

    private
    # Internal: Returns an array of manually added clients.
    #
    # Returns an array of Statsd client classes
    def statsd_clients
      @statsd_clients ||= []
    end

    # Internal: Builds an Statsd client for HostedGraphite.
    #
    # Returns a Statsd class configured for HostedGraphite
    def build_hosted_graphite_statsd_client
      Statsd.new(HOSTED_GRAPHITE_HOST, HOSTED_GRAPHITE_PORT).tap do |statsd|
        statsd.namespace = [
          hosted_graphite_api_key, @hosted_graphite_namespace
        ].compact.join('.')
      end
    end
  end
end
