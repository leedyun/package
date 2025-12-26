# frozen_string_literal: true

module Gitlab
  module Triage
    module APIQueryBuilders
      class BaseQueryParamBuilder
        attr_reader :param_name, :param_contents, :allowed_values

        def initialize(param_name, param_contents, allowed_values: nil)
          @param_name = param_name
          @param_contents = param_contents
          @allowed_values = allowed_values

          validate_allowed_values! if allowed_values
        end

        def build_param
          "&#{param_name}=#{param_content.strip}"
        end

        private

        def validate_allowed_values!
          ParamsValidator.new([{ name: param_name, type: String, values: allowed_values }], { param_name => param_contents }).validate!
        end
      end
    end
  end
end
