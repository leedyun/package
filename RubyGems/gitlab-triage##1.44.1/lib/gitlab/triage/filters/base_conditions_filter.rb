# frozen_string_literal: true

require 'active_support/all'
require_relative '../validators/params_validator'

module Gitlab
  module Triage
    module Filters
      class BaseConditionsFilter
        def initialize(resource, condition)
          @resource = resource
          validate_condition(condition)
          initialize_variables(condition)
        end

        def calculate
          raise NotImplementedError
        end

        def self.filter_parameters
          []
        end

        def self.params_filter_names(params = nil)
          params ||= filter_parameters

          params.pluck(:name)
        end

        def self.all_params_filter_names
          params_filter_names
        end

        def self.params_checking_condition_value
          params_filter_names params_check_for_field(:values)
        end

        def self.params_checking_condition_type
          params_filter_names params_check_for_field(:type)
        end

        def self.params_check_for_field(field)
          filter_parameters.select do |param|
            param[field].present?
          end
        end

        private

        def validate_condition(condition)
          ParamsValidator.new(self.class.filter_parameters, condition).validate!
        end

        def initialize_variables(condition); end
      end
    end
  end
end
