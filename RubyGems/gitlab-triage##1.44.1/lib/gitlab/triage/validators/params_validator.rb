# frozen_string_literal: true

module Gitlab
  module Triage
    class ParamsValidator
      InvalidParameter = Class.new(ArgumentError)

      def initialize(parameter_definitions, value)
        @parameter_definitions = parameter_definitions
        @value = value
      end

      def validate!
        validate_required_parameters(@value)
        validate_parameter_types(@value)
        validate_parameter_content(@value)
      end

      private

      def validate_required_parameters(value)
        @parameter_definitions.each do |param|
          raise InvalidParameter, "#{param[:name]} is a required parameter" unless value[param[:name]]
        end
      end

      def validate_parameter_types(value)
        @parameter_definitions.each do |param|
          if value.has_key?(param[:name])
            param_types = Array(param[:type]).flatten
            raise InvalidParameter, "#{param[:name]} must be of type #{param[:type]}" unless param_types.any? { |type| value[param[:name]].is_a?(type) }
          end
        end
      end

      def validate_parameter_content(value)
        @parameter_definitions.each do |param|
          raise InvalidParameter, "#{param[:name]} must be one of #{param[:values].join(',')}" if param[:values]&.exclude?(value[param[:name]])
        end
      end
    end
  end
end
