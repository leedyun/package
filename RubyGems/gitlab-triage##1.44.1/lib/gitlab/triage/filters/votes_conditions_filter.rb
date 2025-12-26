# frozen_string_literal: true

require_relative 'base_conditions_filter'

module Gitlab
  module Triage
    module Filters
      class VotesConditionsFilter < BaseConditionsFilter
        ATTRIBUTES = %w[upvotes downvotes].freeze
        CONDITIONS = %w[greater_than less_than].freeze

        def self.filter_parameters
          [
            {
              name: :attribute,
              type: String,
              values: ATTRIBUTES
            },
            {
              name: :condition,
              type: String,
              values: CONDITIONS
            },
            {
              name: :threshold,
              type: Numeric
            }
          ]
        end

        def initialize_variables(condition)
          @attribute = condition[:attribute].to_sym
          @condition = condition[:condition].to_sym
          @threshold = condition[:threshold]
        end

        def resource_value
          @resource[@attribute]
        end

        def condition_value
          @threshold
        end

        def calculate
          case @condition
          when :greater_than
            resource_value > condition_value
          when :less_than
            resource_value < condition_value
          end
        end
      end
    end
  end
end
