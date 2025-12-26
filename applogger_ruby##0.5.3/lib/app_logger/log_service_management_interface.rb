class AppLogger::LogServiceManagementInterface

  def initialize(configuration)
    @configuration = configuration
  end

  def announce(inventory, app_id, app_secret)
    # announce the device in the infrastructure
    response = HTTParty.post("#{@configuration.base_uri}/api/harvester/applications/#{app_id}/devices",
                             :headers => { "Authorization" => "Secret #{Base64.encode64(app_secret)}"},
                             :body => { :device => { :identifier => inventory.identifier, :name => inventory.name, :hwtype => inventory.hwtype, :ostype => inventory.ostype }})

    # ok done
    if (response.code == 201)
      return true
    else
      puts ("Failed to announce device with error code #{response.code}")
      return false
    end
  end

  def query_stream_configuration(device_id, app_id, app_secret)
    # request the stream information and let the backend create the stream
    # /api/applications/:app_id/devices/:device_id/streams(.:format
    response = HTTParty.get("#{@configuration.base_uri}/api/harvester/applications/#{app_id}/devices/#{device_id}/stream",
                            :headers => { "Authorization" => "Secret #{Base64.encode64(app_secret)}"})
    unless (response.code == 200)
      puts ("Failed to receive stream config with error code #{response.code}")
      return nil
    end

    # Just build our information model
    AppLogger::LogServiceConfiguration.new(:server => response['stream']['server'], :port => response['stream']['port'], :protocol => response['stream']['protocol'])
  end
end