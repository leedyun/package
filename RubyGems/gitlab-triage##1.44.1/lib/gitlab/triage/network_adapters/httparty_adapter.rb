# frozen_string_literal: true

require 'httparty'

require_relative 'base_adapter'
require_relative '../ui'
require_relative '../errors'

module Gitlab
  module Triage
    module NetworkAdapters
      class HttpartyAdapter < BaseAdapter
        def get(token, url)
          response = HTTParty.get(
            url,
            headers: {
              'User-Agent' => USER_AGENT,
              'Content-type' => 'application/json',
              'PRIVATE-TOKEN' => token
            }
          )

          raise_on_unauthorized_error!(response)
          raise_on_internal_server_error!(response)
          raise_on_too_many_requests!(response)

          {
            more_pages: (response.headers["x-next-page"].to_s != ""),
            next_page_url: next_page_url(url, response),
            results: response.parsed_response,
            ratelimit_remaining: response.headers["ratelimit-remaining"].to_i,
            ratelimit_reset_at: Time.at(response.headers["ratelimit-reset"].to_i)
          }
        end

        def post(token, url, body)
          response = HTTParty.post(
            url,
            body: body.to_json,
            headers: {
              'User-Agent' => "GitLab Triage #{Gitlab::Triage::VERSION}",
              'Content-type' => 'application/json',
              'PRIVATE-TOKEN' => token
            }
          )

          raise_on_unauthorized_error!(response)
          raise_on_internal_server_error!(response)
          raise_on_too_many_requests!(response)

          {
            results: response.parsed_response,
            ratelimit_remaining: response.headers["ratelimit-remaining"].to_i,
            ratelimit_reset_at: Time.at(response.headers["ratelimit-reset"].to_i)
          }
        end

        def delete(token, url)
          response = HTTParty.delete(
            url,
            headers: {
              'User-Agent' => USER_AGENT,
              'PRIVATE-TOKEN' => token
            }
          )

          raise_on_unauthorized_error!(response)
          raise_on_internal_server_error!(response)
          raise_on_too_many_requests!(response)

          {
            results: response.parsed_response,
            ratelimit_remaining: response.headers["ratelimit-remaining"].to_i,
            ratelimit_reset_at: Time.at(response.headers["ratelimit-reset"].to_i)
          }
        end

        private

        def raise_on_unauthorized_error!(response)
          return unless response.response.is_a?(Net::HTTPUnauthorized)

          puts Gitlab::Triage::UI.debug response.inspect if options.debug

          raise 'The provided token is unauthorized!'
        end

        def raise_on_internal_server_error!(response)
          return unless response.response.is_a?(Net::HTTPInternalServerError)

          puts Gitlab::Triage::UI.debug response.inspect if options.debug

          raise Errors::Network::InternalServerError, 'Internal server error encountered!'
        end

        def raise_on_too_many_requests!(response)
          return unless response.response.is_a?(Net::HTTPTooManyRequests)

          puts Gitlab::Triage::UI.debug response.inspect if options.debug

          raise Errors::Network::TooManyRequests, 'Too many requests made!'
        end

        def next_page_url(url, response)
          return unless response.headers['x-next-page'].present?

          next_page = "&page=#{response.headers['x-next-page']}"

          if url.include?('&page')
            url.gsub(/&page=\d+/, next_page)
          else
            url + next_page
          end
        end
      end
    end
  end
end
