# frozen_string_literal: true

require 'active_support/all'
require 'net/protocol'

require_relative 'retryable'
require_relative 'ui'
require_relative 'errors'

module Gitlab
  module Triage
    class RestAPINetwork
      include Retryable

      MINIMUM_RATE_LIMIT = 25

      attr_reader :options, :adapter

      def initialize(adapter)
        @adapter = adapter
        @options = adapter.options
        @cache = {}
      end

      def query_api_cached(url)
        @cache[url] || @cache[url] = query_api(url)
      end

      def query_api(url)
        response = {}
        resources = []

        begin
          print '.'
          url = response.fetch(:next_page_url) { url }

          response = execute_with_retry(
            exception_types: [Net::ReadTimeout, Errors::Network::InternalServerError],
            backoff_exceptions: Errors::Network::TooManyRequests, debug: options.debug) do
            puts Gitlab::Triage::UI.debug "query_api: #{url}" if options.debug

            @adapter.get(token, url)
          end

          results = response.delete(:results)

          case results
          when Array
            resources.concat(results)
          when Hash
            if results['message']&.match?(/404 Group|Project Not Found/)
              raise_unexpected_response(results)
            else
              resources << results
            end
          else
            raise_unexpected_response(results)
          end

          rate_limit_debug(response) if options.debug
          rate_limit_wait(response)
        end while response.delete(:more_pages)

        resources.map!(&:with_indifferent_access)
      end

      def post_api(url, body)
        response = execute_with_retry(
          exception_types: Net::ReadTimeout,
          backoff_exceptions: Errors::Network::TooManyRequests, debug: options.debug) do
          puts Gitlab::Triage::UI.debug "post_api: #{url}" if options.debug

          @adapter.post(token, url, body)
        end

        rate_limit_debug(response) if options.debug
        rate_limit_wait(response)

        results = response.delete(:results)

        case results
        when Hash
          results.with_indifferent_access
        else
          raise_unexpected_response(results)
        end
      end

      def delete_api(url)
        response = execute_with_retry(
          exception_types: Net::ReadTimeout,
          backoff_exceptions: Errors::Network::TooManyRequests, debug: options.debug) do
          puts Gitlab::Triage::UI.debug "delete_api: #{url}" if options.debug

          @adapter.delete(token, url)
        end

        rate_limit_debug(response) if options.debug
        rate_limit_wait(response)
      end

      private

      def token
        options.token
      end

      def rate_limit_debug(response)
        rate_limit_infos = "Rate limit remaining: #{response[:ratelimit_remaining]} (reset at #{response[:ratelimit_reset_at]})"
        puts Gitlab::Triage::UI.debug "rate_limit_infos: #{rate_limit_infos}"
      end

      def rate_limit_wait(response)
        return unless response.delete(:ratelimit_remaining) < MINIMUM_RATE_LIMIT

        puts Gitlab::Triage::UI.debug "Rate limit almost exceeded, sleeping for #{response[:ratelimit_reset_at] - Time.now} seconds" if options.debug
        sleep(1) until Time.now >= response[:ratelimit_reset_at]
      end

      def raise_unexpected_response(results)
        raise Errors::Network::UnexpectedResponse, "Unexpected response: #{results.inspect}"
      end
    end
  end
end
