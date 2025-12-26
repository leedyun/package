require 'faraday'
require 'forwardable'

module FaradayMiddleware
  class AssemblyOAuth2 < Faraday::Middleware
    AUTH_HEADER = 'Authorization'.freeze

    attr_reader :token

    def call(env)
      env[:request_headers][AUTH_HEADER] ||= "Bearer #{token}"
      @app.call env
    end

    def initialize(app, token)
      unless token && token.is_a?(String)
        raise ArgumentError.new("An access_token string was expected, got: #{token.inspect}")
      end
      super(app)
      @token = token
    end
  end
end

Faraday::Request.register_middleware(assembly_oauth2: FaradayMiddleware::AssemblyOAuth2)