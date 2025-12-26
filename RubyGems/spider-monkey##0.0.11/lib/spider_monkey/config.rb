module SpiderMonkey
  mattr_accessor :configuration
  @@configuration = {
    protocol:         "http",
    cloudfront_host:  "",
    user_secret:      "",
    user_key:         "",
    validation_error_handler: ->(message, recoverable, valid_options, invalid_options){puts(message)}
  }
  
  def self.config
    yield self
  end
end