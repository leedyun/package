# frozen_string_literal: true

require_relative 'base_conditions_filter'

module Gitlab
  module Triage
    module Filters
      class MergeRequestDateConditionsFilter < IssueDateConditionsFilter
        def self.generate_allowed_attributes
          super << 'merged_at'
        end
      end
    end
  end
end
