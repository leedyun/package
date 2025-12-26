# frozen_string_literal: true

require_relative 'base_conditions_filter'
require_relative '../url_builders/url_builder'

module Gitlab
  module Triage
    module Filters
      class MemberConditionsFilter < BaseConditionsFilter
        SOURCES = %w[project group].freeze
        CONDITIONS = %w[member_of not_member_of].freeze

        def initialize(resource, condition, network = nil)
          @network = network
          super(resource, condition)
        end

        def self.filter_parameters
          [
            {
              name: :source,
              type: String,
              values: SOURCES
            },
            {
              name: :condition,
              type: String,
              values: CONDITIONS
            },
            {
              name: :source_id,
              type: [Numeric, String]
            }
          ]
        end

        def initialize_variables(condition)
          @source = condition[:source].to_sym
          @condition = condition[:condition].to_sym
          @source_id = condition[:source_id]
        end

        def resource_value
          @resource[member_field][:username] if @resource[member_field]
        end

        def condition_value
          members.pluck(:username)
        end

        def calculate
          return false unless resource_value

          case @condition
          when :member_of
            condition_value.include?(resource_value)
          when :not_member_of
            condition_value.exclude?(resource_value)
          end
        end

        def members
          @members ||= @network.query_api_cached(member_url)
        end

        def member_url
          UrlBuilders::UrlBuilder.new(url_opts).build
        end

        private

        def url_opts
          {
            network_options: @network.options,
            resource_type: 'members',
            source: @source == :group ? 'groups' : 'projects',
            source_id: @source_id,
            params: { per_page: 100 }
          }
        end
      end
    end
  end
end
