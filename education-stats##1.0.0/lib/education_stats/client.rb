module EducationStats
  # EducationStats::Client is responsible for forwarding Statsd commands to a
  # list of Statd clients. Every command will be forwarded to ALL clients,
  # making this a very distinct concept from Statd shards / sharding which
  # distributes the call load over multiple shards. Multiple shards may still be
  # used in a Statsd instance added through the add 'add_statsd_client' method.
  class Client
    attr_reader :all_clients

    # A list of forwarding methods to build
    FORWARD_METHODS = [
      :increment,
      :decrement,
      :count,
      :guage,
      :timing,
      :time
    ].freeze

    # Public: Constructor for Client class.
    #
    # clients - An array of configured Statd client classes. Commands will be
    # forwarded to each of these clients.
    #
    # Returns a EducationStats::Client instance
    def initialize(clients)
      @all_clients = clients
    end

    # Public: Statsd command methods. Commands and all arguments are simply
    # forwarded to every Statsd client.
    #
    # Returns an array of return values from the command called on each client.
    FORWARD_METHODS.each do |method|
      define_method method do |*args|
        @all_clients.map { |client| client.__send__(method, *args) }
      end
    end
  end
end
