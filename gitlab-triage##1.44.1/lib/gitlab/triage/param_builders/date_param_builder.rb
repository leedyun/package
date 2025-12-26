# frozen_string_literal: true

require_relative '../validators/params_validator'

module Gitlab
  module Triage
    module ParamBuilders
      class DateParamBuilder
        CONDITIONS = %w[older_than newer_than].freeze
        TIME_BASED_INTERVALS = %w[minutes hours].freeze
        DATE_BASED_INTERVALS = %w[days weeks months years].freeze
        INTERVAL_TYPES = TIME_BASED_INTERVALS + DATE_BASED_INTERVALS

        def initialize(allowed_attributes, condition_hash)
          @allowed_attributes = allowed_attributes
          @attribute = condition_hash[:attribute].to_s
          @interval_condition = condition_hash[:condition].to_sym
          @interval_type = condition_hash[:interval_type]
          @interval = condition_hash[:interval]

          validate_condition(condition_hash)
        end

        def param_content
          if TIME_BASED_INTERVALS.include?(interval_type)
            interval.public_send(interval_type).ago.to_datetime # rubocop:disable GitlabSecurity/PublicSend
          else
            interval.public_send(interval_type).ago.to_date # rubocop:disable GitlabSecurity/PublicSend
          end
        end

        private

        attr_reader :allowed_attributes, :attribute, :interval_condition, :interval_type, :interval

        def validate_condition(condition)
          ParamsValidator.new(filter_parameters, condition).validate!
        end

        def filter_parameters
          [
            {
              name: :attribute,
              type: String,
              values: allowed_attributes
            },
            {
              name: :condition,
              type: String,
              values: CONDITIONS
            },
            {
              name: :interval_type,
              type: String,
              values: INTERVAL_TYPES
            },
            {
              name: :interval,
              type: Numeric
            }
          ]
        end
      end
    end
  end
end
