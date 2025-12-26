require 'ansi'
require "acception/client"
require "acception/subscriber/version"

module Acception
  module Subscriber

    autoload :Configuration,  'acception/subscriber/configuration'
    autoload :Logging,        'acception/subscriber/logging'
    autoload :MessageHandler, 'acception/subscriber/message_handler'
    autoload :Server,         'acception/subscriber/server'
    autoload :ServerDaemon,   'acception/subscriber/server_daemon'
    autoload :ServerLogging,  'acception/subscriber/server_logging'

    APP_ID            = "acception-sub"
    APP_NAME          = "Acception Subscriber"
    COMPANY           = "Iberon, LLC"
    INT               = "INT"
    TERM              = "TERM"
    VERSION_COPYRIGHT = "v#{VERSION} \u00A9#{Time.now.year} #{COMPANY}"

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configuration=( configuration )
      @configuration = configuration
    end

    def self.configure
      yield( configuration ) if block_given?
    end

    class << self
      attr_accessor :logger
    end

  end
end
