require 'typhoeus'

module TelegramBotApi
  class HttpClient

    def self.make_request(verb:, url:, params:)
      method = case verb
      when :get
        :get
      when :post
        :post
      end

      unless method
        raise(ArgumentError, "Invalid verb")
      end

      self.send(method, url: url, params: params)
    end

    private

    def self.get(url:, params: {})
      Typhoeus.get(url,  headers: {'Content-Type'=> "application/json"}, params: params)
    end

    def self.post(url:, params: {})
      Typhoeus.post(url,  headers: {'Content-Type'=> "application/json"}, params: params)
    end
  end
end
