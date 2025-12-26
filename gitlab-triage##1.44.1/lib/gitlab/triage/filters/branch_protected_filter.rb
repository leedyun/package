# frozen_string_literal: true

require_relative 'base_conditions_filter'

module Gitlab
  module Triage
    module Filters
      class BranchProtectedFilter < BaseConditionsFilter
        def initialize_variables(config_value)
          @attribute = :protected
          @condition = config_value.nil? ? true : config_value
        end

        def resource_value
          @resource[:protected]
        end

        def condition_value
          @condition
        end

        def calculate
          resource_value == condition_value
        end
      end
    end
  end
end
