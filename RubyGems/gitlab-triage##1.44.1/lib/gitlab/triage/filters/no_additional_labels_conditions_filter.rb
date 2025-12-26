# frozen_string_literal: true

require_relative 'base_conditions_filter'

module Gitlab
  module Triage
    module Filters
      class NoAdditionalLabelsConditionsFilter < BaseConditionsFilter
        def self.filter_parameters
          []
        end

        def validate_condition(condition)
          raise ArgumentError, 'condition must be an array containing the only label values allowed' unless condition.is_a?(Array)
        end

        def initialize_variables(expected_labels)
          @attribute = :labels
          @expected_labels = expected_labels
        end

        def resource_value
          @resource[@attribute]
        end

        def calculate
          (resource_value - @expected_labels).empty?
        end
      end
    end
  end
end
