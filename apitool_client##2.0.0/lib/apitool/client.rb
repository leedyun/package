require "apitool/client/version"

require "rails"
require "rest-client"
require "apitool/client/logger"

require "apitool/client/apitool_client"
require "apitool/client/vpn"
require "apitool/client/backup"

module Apitool
  module Client

    def self.logger
      @logger || Apitool::Client::Logger
    end

    def self.logger=(logger)
      @logger = logger
    end

    class Railtie < ::Rails::Railtie
      initializer :apitool_client do |app|
        # Apitool::Client.logger = Rails.logger
      end
    end

  end
end
