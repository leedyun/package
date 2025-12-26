require 'uri'
require 'net/http'

module AuthenticatedClient
  class Client
    attr_accessor :url
    attr_accessor :token
    attr_accessor :verb
    attr_accessor :parameters
    attr_accessor :body
    attr_accessor :auditing

    def initialize
      @url = nil
      @token = nil
      @verb = :post
      @parameters = {}
      @body = {}
      @auditing = nil
    end

    def request
      validate_elements_before_performing_request
      perform_http_request
    end

    private

    def perform_http_request(csrf_header = 'X-CSRF-Validation')
      uri = URI.parse(@url)
      uri.query = URI.encode_www_form( @parameters )
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.is_a?(URI::HTTPS)
      request = Net::HTTP::Post.new(uri.request_uri) if :post == @verb
      request = Net::HTTP::Get.new(uri.request_uri) if :get == @verb
      request.add_field("AUTHORIZATION", @token) if @token
      request.add_field(csrf_header, '')
      request.body = body.to_json
      http.request(request)
    end

    def validate_elements_before_performing_request
      raise 'only verbs post and get are supported' unless [:post, :get].include?(@verb)
      raise "invalid url #{@url}" unless @url =~ URI::regexp
      raise "parameters must be a hash" unless @parameters.is_a?(Hash)
      raise "body must be a hash" unless @body.is_a?(Hash)
    end

    def audit_failure

    end
  end
end
