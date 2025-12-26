class AppLogger::LogConnection

  def initialize(configuration)
    @configuration = configuration
    @log_queue = Queue.new
    @receivers_available = false
  end

  # :app_identifier => THE IDENTIFIER OF THE APP
  # :app_secret     => THE SECRET OF THE APP

  def open(options = {})

    # generate an instance of the management interface to advertise the harvester for this
    # log session
    mgnt_svc = AppLogger::LogServiceManagementInterface.new(@configuration)

    # use the management interface to announce the given device
    device_inventory = AppLogger::LogServiceDeviceInventory.discover
    puts "Announcing device with the following settings: #{device_inventory.name} (#{device_inventory.identifier})"
    return unless mgnt_svc.announce(device_inventory, options[:app_identifier], options[:app_secret])

    # after announcing our device it's important to get the streaming configuration from the service
    puts "Receiving stream configuration..."
    stream_config = mgnt_svc.query_stream_configuration(device_inventory.identifier, options[:app_identifier], options[:app_secret])
    return unless stream_config

    # just log some information
    puts "Logging to the following server: #{stream_config.base_uri}"
    query = "client=harvester&app=#{options[:app_identifier]}&device=#{device_inventory.identifier}&signature=#{Base64.encode64(options[:app_secret])}";

    Thread.new {
      # we create the logging client
      @client = AppLogger::LogSocketIo.connect(stream_config.base_uri, :query => query)

      # establish the event handlers
      @client.on_connect() do
        puts "Opened connection to the websocket service"
      end

      @client.on_event("connection.established") do
        puts "Connection established, validated, processing messages"
      end

      @client.on_event("harvester.users") do |data|
        receivers_watching = data.first["users"].count
        @receivers_available = (receivers_watching != 0)
        puts "Logging #{@receivers_available ? "enabled" : "disabled"}, #{receivers_watching} receivers watching this stream"
      end

      # and start the loop
      @client.run
    }
  end

  def write(message)
    # check if we write logs
    return unless @receivers_available

    # encode the message
    encoded_message = Base64.encode64(message).gsub(/\n/, '')

    # send the logs
    if @client && @client.connected?
      while !@log_queue.empty? do
        old_message = @log_queue.pop
        @client.send_event('harvester.log' , { data: old_message})
      end

      @client.send_event('harvester.log' , { data: encoded_message})
    else
      @log_queue.push(encoded_message)
    end
  end

  def close
    @client.disconnect if @client
  end

  def registration_link(app_id)
    device_inventory = AppLogger::LogServiceDeviceInventory.discover
    "#{@configuration.base_uri}/api/applications/#{app_id}/devices/new?identifier=#{URI::encode(device_inventory.identifier)}&name=#{URI::encode(device_inventory.name)}"
  end

end