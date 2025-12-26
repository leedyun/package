require 'endow'
require 'enumerative'
require 'hashie'
require 'time'
require 'acception/message_type'
require 'acception/client/version'

module Acception
  module Client

    autoload :Configuration, 'acception/client/configuration'
    autoload :Data,          'acception/client/data'
    autoload :Endpoint,      'acception/client/endpoint'
    autoload :Errors,        'acception/client/errors'
    autoload :Messages,      'acception/client/messages'
    autoload :OpenMessages,  'acception/client/open_messages'

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield( configuration ) if block_given?
    end

    I18n.load_path += Dir[File.expand_path( '../../../config/locales', __FILE__ ) + '/*.{rb,yml}']

  end
end
