# frozen_string_literal: true

require 'net/http'
require 'uri'

module Gitlab
  module QA
    module Support
      class GetRequest
        attr_reader :uri, :token

        def initialize(uri, token)
          @uri = uri
          @token = token
        end

        def execute!
          response = with_retry_on_too_many_requests do
            Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
              http.request(build_request)
            end
          end

          case response
          when Net::HTTPSuccess
            response
          else
            raise Support::InvalidResponseError.new(uri.to_s, response)
          end
        end

        private

        def build_request
          Net::HTTP::Get.new(uri).tap do |req|
            req['PRIVATE-TOKEN'] = token
            req['Cookie'] = ENV['QA_COOKIES'] if ENV['QA_COOKIES']
          end
        end

        def with_retry_on_too_many_requests
          response = nil
          retry_count = 0

          while retry_count < 3
            response = yield

            break unless response.is_a?(Net::HTTPTooManyRequests)

            retry_count += 1
            wait_seconds = response["retry-after"].to_i
            Runtime::Logger.debug("Received 429 - Too many requests. Waiting for #{wait_seconds} seconds.")
            sleep wait_seconds
          end

          response
        end
      end
    end
  end
end
