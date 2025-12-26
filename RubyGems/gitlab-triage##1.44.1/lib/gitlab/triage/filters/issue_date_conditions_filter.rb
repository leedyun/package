# frozen_string_literal: true

require_relative 'base_conditions_filter'

module Gitlab
  module Triage
    module Filters
      class IssueDateConditionsFilter < BaseConditionsFilter
        CONDITIONS = %w[older_than newer_than].freeze
        TIME_BASED_INTERVALS = %w[minutes hours].freeze
        DATE_BASED_INTERVALS = %w[days weeks months years].freeze
        INTERVAL_TYPES = TIME_BASED_INTERVALS + DATE_BASED_INTERVALS

        def self.generate_allowed_attributes
          %w[updated_at created_at]
        end

        def self.allowed_attributes
          @allowed_attributes ||= generate_allowed_attributes.freeze
        end

        def self.filter_parameters
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

        def initialize_variables(condition)
          @attribute = condition[:attribute].to_sym
          @condition = condition[:condition].to_sym
          @interval_type = condition[:interval_type].to_sym
          @interval = condition[:interval]
        end

        # Guard against merge requests with no merged_at values
        def resource_value
          @resource[@attribute]&.to_date
        end

        def condition_value
          if TIME_BASED_INTERVALS.include?(@interval_type.to_s)
            @interval.public_send(@interval_type).ago.to_datetime # rubocop:disable GitlabSecurity/PublicSend
          else
            @interval.public_send(@interval_type).ago.to_date # rubocop:disable GitlabSecurity/PublicSend
          end
        end

        # Guard against merge requests with no merged_at values
        def calculate
          return false unless resource_value

          case @condition
          when :older_than
            resource_value < condition_value
          when :newer_than
            resource_value > condition_value
          end
        end
      end
    end
  end
end
