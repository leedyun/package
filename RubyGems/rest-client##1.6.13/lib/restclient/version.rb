module RestClient
  VERSION = '1.6.13' unless defined?(self::VERSION)

  def self.version
    VERSION
  end
end
