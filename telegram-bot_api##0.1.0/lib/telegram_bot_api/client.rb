module TelegramBotApi
  class Client
    TELEGRAM_API_ENDPOINT = "https://api.telegram.org"

    def self.execute(request)
      unless request.valid?
        raise(ArgumentError, request.errors)
      end
      HttpClient.make_request(verb: request.verb, url: request_url(request), params: request.to_json)
    end

    private

    def self.request_url(request)
      "#{TELEGRAM_API_ENDPOINT}/#{bot_path}/#{request.endpoint_url}"

    end

    def self.bot_path
      auth_token = TelegramBotApi.configuration.auth_token
      "bot#{auth_token}"
    end
  end
end
