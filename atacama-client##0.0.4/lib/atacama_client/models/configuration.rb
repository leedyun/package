require "singleton"

module AtacamaClient
  class Configuration
    include Singleton

    attr_accessor :api_token
  end
end
