# frozen_string_literal: true

require 'active_support/all'
require 'net/protocol'
require 'globalid'

require_relative 'retryable'
require_relative 'ui'
require_relative 'errors'

module Gitlab
  module Triage
    class GraphqlNetwork
      attr_reader :options, :adapter

      MINIMUM_RATE_LIMIT = 25

      def initialize(adapter)
        @adapter = adapter
        @options = adapter.options
      end

      def query(graphql_query, variables = {})
        return if graphql_query.blank?

        response = {}
        resources = []

        parsed_graphql_query = adapter.parse(graphql_query.query)

        begin
          print '.'

          response = adapter.query(
            parsed_graphql_query,
            resource_path: graphql_query.resource_path,
            variables: variables.merge(after: response.delete(:end_cursor))
          )

          rate_limit_debug(response) if options.debug
          rate_limit_wait(response)

          resources.concat(Array.wrap(response.delete(:results)))
        end while response.delete(:more_pages)

        resources
          .map { |resource| resource.deep_transform_keys(&:underscore) }
          .map(&:with_indifferent_access)
          .map { |resource| normalize(resource) }
      end

      private

      def normalize(resource)
        resource
          .slice(:iid, :title, :state, :author, :merged_at, :user_notes_count, :user_discussions_count, :upvotes, :downvotes, :project_id, :web_url)
          .merge(
            id: extract_id_from_global_id(resource[:id]),
            labels: [*resource.dig(:labels, :nodes)].pluck(:title),
            assignees: [*resource.dig(:assignees, :nodes)]
          )
      end

      def extract_id_from_global_id(global_id)
        return if global_id.blank?

        GlobalID.parse(global_id).model_id.to_i
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
    end
  end
end
