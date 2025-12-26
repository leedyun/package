# frozen_string_literal: true

require 'graphql/client'
require 'graphql/client/http'

require_relative 'base_adapter'
require_relative '../ui'
require_relative '../errors'

module Gitlab
  module Triage
    module NetworkAdapters
      class GraphqlAdapter < BaseAdapter
        Client = GraphQL::Client

        def query(graphql_query, resource_path: [], variables: {})
          response = client.query(graphql_query, variables: variables, context: { token: options.token })

          raise_on_error!(response)

          parsed_response = parse_response(response, resource_path)
          headers = response.extensions.fetch('headers', {})

          graphql_response = {
            ratelimit_remaining: headers['ratelimit-remaining'].to_i,
            ratelimit_reset_at: Time.at(headers['ratelimit-reset'].to_i)
          }

          return graphql_response.merge(results: {}) if parsed_response.nil?
          return graphql_response.merge(results: parsed_response.map(&:to_h)) if parsed_response.is_a?(Client::List)
          return graphql_response.merge(results: parsed_response.to_h) unless parsed_response.nodes?

          graphql_response.merge(
            more_pages: parsed_response.page_info.has_next_page,
            end_cursor: parsed_response.page_info.end_cursor,
            results: parsed_response.nodes.map(&:to_h)
          )
        end

        delegate :parse, to: :client

        private

        def parse_response(response, resource_path)
          resource_path.reduce(response.data) { |data, resource| data&.send(resource) } # rubocop:disable GitlabSecurity/PublicSend
        end

        def raise_on_error!(response)
          return if response.errors.blank?

          puts Gitlab::Triage::UI.debug response.inspect if options.debug

          raise "There was an error: #{response.errors.messages.to_json}"
        end

        def http_client
          Client::HTTP.new("#{options.host_url}/api/graphql") do
            def execute(document:, operation_name: nil, variables: {}, context: {}) # rubocop:disable Lint/NestedMethodDefinition
              body = {}
              body['query'] = document.to_query_string
              body['variables'] = variables if variables.any?
              body['operationName'] = operation_name if operation_name

              response = HTTParty.post(
                uri,
                body: body.to_json,
                headers: {
                  'User-Agent' => USER_AGENT,
                  'Content-type' => 'application/json',
                  'PRIVATE-TOKEN' => context[:token]
                }
              )

              case response.code
              when 200, 400
                JSON.parse(response.body).merge('extensions' => { 'headers' => response.headers })
              else
                { 'errors' => [{ 'message' => "#{response.code} #{response.message}" }] }
              end
            end
          end
        end

        def schema
          @schema ||= Client.load_schema(http_client)
        end

        def client
          @client ||= Client.new(schema: schema, execute: http_client).tap { |client| client.allow_dynamic_queries = true }
        end
      end
    end
  end
end
