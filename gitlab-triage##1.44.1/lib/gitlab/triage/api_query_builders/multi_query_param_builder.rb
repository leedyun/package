# frozen_string_literal: true

require_relative 'base_query_param_builder'

module Gitlab
  module Triage
    module APIQueryBuilders
      class MultiQueryParamBuilder < BaseQueryParamBuilder
        attr_reader :separator

        def initialize(param_name, param_contents, separator, allowed_values: nil)
          @separator = separator
          super(param_name, Array(param_contents), allowed_values: allowed_values)
        end

        def param_content
          param_contents.map(&:strip).join(separator)
        end

        private

        def validate_allowed_values!
          param_contents.each do |param|
            ParamsValidator.new([{ name: param_name, type: String, values: allowed_values }], { param_name => param }).validate!
          end
        end
      end
    end
  end
end
