require 'virtus'
require 'awrence'
require "advisors_command_client/version"
require 'advisors_command_client/connection'
require 'advisors_command_client/models/base'
require 'advisors_command_client/models/address'
require 'advisors_command_client/models/contact'
require 'advisors_command_client/models/account'
require 'advisors_command_client/models/contact_collection'
require 'advisors_command_client/models/account_collection'

module AdvisorsCommandClient
  class SearchError < ::StandardError
  end

  class MissingAPIUrlError < ::StandardError
  end

  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield config
  end

  class Configuration
    attr_accessor :api_url
  end

  class Client
    # STAGING_URL = "https://qa.advisorscommand.com/api/rest/latest"
    # DEMO_URL = "https://demo.advisorscommand.com/api/rest/latest"
    # PROD_URL = "https://advisorscommand.com/api/rest/latest"
    attr_reader :connection

    def initialize(username, api_key, options = {})
      url = AdvisorsCommandClient.config.api_url || options[:api_url]

      raise MissingAPIUrlError.new('A url for this client has not been configured.') if url.nil?

      @connection = AdvisorsCommandClient::Connection.new(username, api_key, url).build
    end

    def contacts
      @contacts ||= Models::ContactCollection.new(connection: @connection)
    end

    def accounts
      @accounts ||= Models::AccountCollection.new(connection: @connection)
    end
  end
end
