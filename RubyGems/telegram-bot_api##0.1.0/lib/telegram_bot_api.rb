require_relative "telegram_bot_api/version"
require_relative "telegram_bot_api/configuration"
require_relative "telegram_bot_api/http_client"
require_relative "telegram_bot_api/client"
require_relative "telegram_bot_api/message"
require_relative "telegram_bot_api/requests"

module TelegramBotApi

  @configuration = Configuration.new

  class << self
    attr_accessor :configuration
  end

  def self.configure
    yield(configuration)
  end
end
