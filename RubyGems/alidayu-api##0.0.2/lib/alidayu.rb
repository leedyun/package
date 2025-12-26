require "alidayu/version"
require "alidayu/configuration"
require "alidayu/helper"
require "alidayu/sms"
require "alidayu/tts"
require "alidayu/voice"
require "logger"


module Alidayu
  
  class << self
    def setup
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
