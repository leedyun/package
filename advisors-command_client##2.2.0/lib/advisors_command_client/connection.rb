require 'parallel'
require 'akami'
require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

module AdvisorsCommandClient
  class Connection

    def initialize(username, api_key, url)
      @username = username
      @api_key = api_key
      @url = url
    end

    def build
      Faraday.new(@url) do |faraday|
        faraday.request :json
        faraday.use AdvisorsCommandClient::Connection::WsseAuth, @username, @api_key
        faraday.adapter :typhoeus
        faraday.response :json, content_type: /\bjson$/
      end
    end

    class WsseAuth < Faraday::Middleware
      def initialize(app, username, api_key)
        super(app)
        @username = username
        @api_key = api_key
      end

      def call(request_env)
        request_env[:request_headers].merge!({"X-WSSE" => wsse_auth_string})
        @app.call(request_env)
      end

      private
      def wsse_auth_string
        wsse = Akami.wsse
        wsse.credentials @username, @api_key, :digest
        wsse.timestamp = true

        %{UsernameToken Username="#{wsse.username}", PasswordDigest="#{wsse.send(:digest_password)}", Nonce="#{Base64.encode64(wsse.send(:nonce)).chomp}", Created="#{wsse.send(:timestamp)}"}
      end
    end
  end
end