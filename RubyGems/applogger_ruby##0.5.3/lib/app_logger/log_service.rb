class AppLogger::LogService

  # Call the connect method to get a valid connection to the service. With the connection it's possible to
  # send logs to the service. The following variants are available
  #
  # :configuration  => PATH TO SERVICE CONFIG
  #
  # The call returns a valid connection object which can be used for sending logs. As long as the connection
  # object exists the system maintains a websocket tunnel to the service.
  #
  def self.connect(options = {})

    # First of all get the configuration we need for the connection
    puts "Reading configuration for connection..."
    configuration = read_config(options[:configuration])

    # Log out the current configuration
    puts "Connecting to server #{configuration.base_uri}"

    # Now we are able to establish a connection object
    AppLogger::LogConnection.new(configuration)
  end

  private

  def self.read_config(configuration)
    # check if we have a valid file
    unless configuration && File.exists?(configuration)
      puts "Using default configuration for connection..."
      configuration = File.join(File.dirname(__FILE__), '..', '..', 'config','service.json')
    end

    # read the configuration
    configuration = JSON.parse(File.read(configuration))

    # map to the config model
    AppLogger::LogServiceConfiguration.new( :server => configuration['applogger']['server'],
                                            :port => configuration['applogger']['port'],
                                            :protocol => configuration['applogger']['protocol'])
  end

end