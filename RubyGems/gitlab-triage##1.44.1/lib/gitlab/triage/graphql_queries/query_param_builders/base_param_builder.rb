# frozen_string_literal: true

require_relative '../../utils'

module Gitlab
  module Triage
    module GraphqlQueries
      module QueryParamBuilders
        class BaseParamBuilder
          attr_reader :param_name, :param_contents, :with_quotes, :negated

          def initialize(param_name, param_contents, with_quotes: true, negated: false)
            @param_name = param_name
            @param_contents = param_contents.to_s.strip
            @with_quotes = with_quotes
            @negated = negated
          end

          def build_param
            contents = with_quotes ? Utils.graphql_quote(param_contents) : param_contents

            if negated
              ", not: { #{param_name}: #{contents} }"
            else
              ", #{param_name}: #{contents}"
            end
          end
        end
      end
    end
  end
end
