class AppLogger::LogSocketIo

  def self.connect(service_uri, options = {})
    # First of all we need to auhtorize against the socket.io engine by calling
    # with a standard rest client
    query = options[:query]
    query = "?#{query}" if query

    response = HTTParty.get("#{service_uri}/socket.io/1/#{query}")
    return nil unless response.code == 200

    # Form the answer we need to extract the handshake token by splitting the data at :
    response_data = response.body.split(':')
    return nil unless response_data.count == 4

    # Now we just generate the real websocket url
    websocket_uri = service_uri.sub 'http://', 'ws://'
    websocket_uri = websocket_uri.sub 'https://', 'wss://'
    websocket_uri = "#{websocket_uri}/socket.io/1/websocket/#{response_data[0]}"

    # we generate the client
    AppLogger::LogSocketIo.new(websocket_uri)
  end

  def initialize(websocket_uri)
    @socket_uri = websocket_uri
    @on_disconnect    = nil
    @on_connect       = nil
    @on_heartbeat     = nil
    @on_message       = nil
    @on_json_message  = nil
    @on_event         = {}
    @on_ack           = nil
    @on_error         = nil
    @on_noop          = nil
  end

  def run
    # We starting a new connection so allow to reconnect
    @reconnect = true

    # At this point we can start the event machine which handles the socket events
    EM.run {
      # Build a webservice client
      @ws = Faye::WebSocket::Client.new(@socket_uri)

      # This will be triggered when an event was send
      # from the server
      @ws.on :message do |event|
        # parse the message
        decoded = AppLogger::LogSocketIoParser.decode(event.data)

        case decoded[:type]
          when '0'
            @on_disconnect.call if @on_disconnect
          when '1'
            @on_connect.call if @on_connect
          when '2'
            send_heartbeat
            @on_heartbeat.call if @on_heartbeat
          when '3'
            @on_message.call decoded[:data] if @on_message
          when '4'
            @on_json_message.call decoded[:data] if @on_json_message
          when '5'
            message = JSON.parse(decoded[:data])
            @on_event[message['name']].call message['args'] if @on_event[message['name']]
          when '6'
            @on_ack.call if @on_ack
          when '7'
            @on_error.call decoded[:data] if @on_error
          when '8'
            @on_noop.call if @on_noop
        end
      end

      @ws.on :close do |event|
        @ws = nil
        disconnected
      end
    }
  end

  def on_disconnect(&block)
    @on_disconnect = block
  end

  def on_connect(&block)
    @on_connect = block
  end

  def on_heartbeat(&block)
    @on_heartbeat = block
  end

  def on_message(&block)
    @on_message = block
  end

  def on_json_message(&block)
    @on_json_message = block
  end

  def on_event(name, &block)
    @on_event[name] = block
  end

  def on_ack(&block)
    @on_ack = block
  end

  def on_error(&block)
    @on_error = block
  end

  def on_noop(&block)
    @on_noop = block
  end

  def send_event(name, hash)
    @ws.send("5:::#{{name: name, args: [hash]}.to_json}") if @ws
  end

  def connected?
    @ws != nil
  end

  def disconnect
    @reconnect = false
    @ws.send("0::")
  end

  private

  def send_heartbeat
    @ws.send("2::")
  end

  def disconnected
    if @reconnect
      run
    end
  end
end