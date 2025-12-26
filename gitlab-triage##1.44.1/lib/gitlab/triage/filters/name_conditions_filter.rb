# frozen_string_literal: true

require_relative 'base_conditions_filter'

module Gitlab
  module Triage
    module Filters
      class NameConditionsFilter < BaseConditionsFilter
        def initialize_variables(matching_name)
          @attribute = :name
          @matching_name = matching_name
        end

        def resource_value
          @resource[@attribute]
        end

        def condition_value
          @matching_name
        end

        def calculate
          resource_value == condition_value
        end
      end
    end
  end
end
