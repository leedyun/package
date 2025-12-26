# frozen_string_literal: true

require_relative 'query_param_builders/base_param_builder'
require_relative 'query_param_builders/date_param_builder'
require_relative 'query_param_builders/array_param_builder'

module Gitlab
  module Triage
    module GraphqlQueries
      class QueryBuilder
        def initialize(source_type, resource_type, conditions, graphql_only: false)
          @source_type = source_type.to_s.singularize
          @resource_type = resource_type
          @conditions = conditions
          @graphql_only = graphql_only
          @resource_declarations = [
            '$source: ID!',
            '$after: String'
          ]

          has_any_iids = conditions.each_key.find { |key| key.to_s == 'iids' }
          @resource_declarations << '$iids: [String!]' if has_any_iids
        end

        def resource_path
          [source_type, resource_type]
        end

        def query
          return if resource_fields.empty?

          format(
            BASE_QUERY,
            source_type: source_type,
            resource_type: resource_type.to_s.camelize(:lower),
            resource_fields: resource_fields.join(' '),
            resource_query: resource_query,
            resource_declarations: resource_declarations.join(', ')
          )
        end

        delegate :any?, to: :resource_fields

        private

        attr_reader :source_type, :resource_type, :conditions, :graphql_only, :resource_declarations

        BASE_QUERY = <<~GRAPHQL
          query(%{resource_declarations}) {
            %{source_type}(fullPath: $source) {
              id
              %{resource_type}(after: $after%{resource_query}) {
                pageInfo {
                  hasNextPage
                  endCursor
                }
                nodes {
                  id iid title updatedAt createdAt webUrl projectId %{resource_fields}
                }
              }
            }
          }
        GRAPHQL

        def vote_attribute
          @vote_attribute ||= (conditions.dig(:votes, :attribute) || conditions.dig(:upvotes, :attribute)).to_s
        end

        def resource_fields
          fields = []

          fields << 'userNotesCount' if conditions.dig(:discussions, :attribute).to_s == 'notes'
          fields << 'userDiscussionsCount' if conditions.dig(:discussions, :attribute).to_s == 'threads'

          if graphql_only
            fields << 'labels { nodes { title } }'
            fields << 'author { id name username }'
            fields << 'assignees { nodes { id name username } }' if conditions.key?(:assignee_member)
            fields << 'upvotes' if vote_attribute == 'upvotes'
            fields << 'downvotes' if vote_attribute == 'downvotes'
            fields.push('draft', 'mergedAt') if resource_type == 'merge_requests'
          end

          fields
        end

        def resource_query
          condition_queries = []

          condition_queries << QueryParamBuilders::BaseParamBuilder.new('includeSubgroups', true, with_quotes: false) if source_type == 'group'

          conditions.each do |condition, condition_params|
            condition_queries << QueryParamBuilders::DateParamBuilder.new(condition_params) if condition.to_s == 'date'
            condition_queries << QueryParamBuilders::BaseParamBuilder.new('authorUsername', condition_params) if condition.to_s == 'author_username'
            condition_queries << QueryParamBuilders::BaseParamBuilder.new('milestoneTitle', condition_params) if condition.to_s == 'milestone'
            condition_queries << QueryParamBuilders::BaseParamBuilder.new('state', condition_params, with_quotes: false) if condition.to_s == 'state'
            condition_queries << QueryParamBuilders::BaseParamBuilder.new('iids', '$iids', with_quotes: false) if condition.to_s == 'iids'

            case resource_type
            when 'issues'
              condition_queries << issues_label_query(condition, condition_params)
              condition_queries << issues_type_query(condition, condition_params)
            when 'merge_requests'
              condition_queries << merge_requests_label_query(condition, condition_params)
              condition_queries << merge_requests_resource_query(condition, condition_params)
            end
          end

          condition_queries
            .compact
            .map(&:build_param)
            .join
        end

        def issues_label_query(condition, condition_params)
          args =
            case condition.to_s
            when 'forbidden_labels'
              ['labelName', condition_params, { negated: true }]
            when 'labels'
              ['labelName', condition_params, {}]
            else
              return nil
            end

          QueryParamBuilders::ArrayParamBuilder.new(*args[0...-1], **args.last)
        end

        def issues_type_query(condition, condition_params)
          return unless condition.to_s == 'issue_type'

          QueryParamBuilders::ArrayParamBuilder.new('types', [condition_params.upcase], with_quotes: false)
        end

        def merge_requests_resource_query(condition, condition_params)
          args =
            case condition.to_s
            when 'source_branch'
              ['sourceBranches', condition_params, {}]
            when 'target_branch'
              ['targetBranches', condition_params, {}]
            when 'draft'
              ['draft', condition_params, { with_quotes: false }]
            else
              return nil
            end

          QueryParamBuilders::BaseParamBuilder.new(*args[0...-1], **args.last)
        end

        def merge_requests_label_query(condition, condition_params)
          args =
            case condition.to_s
            when 'forbidden_labels'
              ['labels', condition_params, { negated: true }]
            when 'labels'
              ['labelName', condition_params, {}]
            else
              return nil
            end

          QueryParamBuilders::ArrayParamBuilder.new(*args[0...-1], **args.last)
        end
      end
    end
  end
end
