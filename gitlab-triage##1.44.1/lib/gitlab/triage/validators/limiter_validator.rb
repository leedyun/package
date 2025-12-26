# frozen_string_literal: true

require_relative 'params_validator'

module Gitlab
  module Triage
    class LimiterValidator < ParamsValidator
      private

      def params_limiter_names
        @parameter_definitions.pluck(:name)
      end

      def validate_required_parameters(value)
        return if value.keys.one? { |key| params_limiter_names.include?(key.to_sym) }

        raise ArgumentError, "For the limits field, please specify one of: `#{params_limiter_names.join('`, `')}`"
      end
    end
  end
end
