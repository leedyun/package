# frozen_string_literal: true

require_relative 'base_query_param_builder'

module Gitlab
  module Triage
    module APIQueryBuilders
      class SingleQueryParamBuilder < BaseQueryParamBuilder
        def param_content
          param_contents
        end
      end
    end
  end
end
