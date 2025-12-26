class AppLogger::LogServiceConfiguration
  attr_accessor :server
  attr_accessor :port
  attr_accessor :protocol

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def base_uri
    "#{@protocol}://#{@server}:#{@port}"
  end
end