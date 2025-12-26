# frozen_string_literal: true

require_relative '../../utils'
require_relative 'base_param_builder'

module Gitlab
  module Triage
    module GraphqlQueries
      module QueryParamBuilders
        class ArrayParamBuilder < BaseParamBuilder
          def initialize(param_name, values, with_quotes: true, negated: false)
            quoted_values = values.map do |value|
              if with_quotes
                Utils.graphql_quote(value)
              else
                value
              end
            end

            array_param_content =
              quoted_values.join(', ').then { |content| "[#{content}]" }

            super(param_name, array_param_content, with_quotes: false, negated: negated)
          end
        end
      end
    end
  end
end
