# frozen_string_literal: true

require_relative 'base_limiter'
require_relative '../validators/limiter_validator'

module Gitlab
  module Triage
    module Limiters
      class DateFieldLimiter < BaseLimiter
        LIMITS = %i[most_recent oldest].freeze

        def self.limiter_parameters
          [
            {
              name: :most_recent,
              type: Integer
            },
            {
              name: :oldest,
              type: Integer
            }
          ]
        end

        def initialize_variables(limit)
          @criterion = LIMITS.find(&limit.method(:[]))
          @threshold = limit[@criterion]
        end

        def limit
          case @criterion
          when :oldest
            @resources.first(@threshold)
          when :most_recent
            @resources.last(@threshold).reverse
          end
        end

        private

        def initialize_resources(resources)
          resources.sort_by { |res| res[:created_at] }
        end
      end
    end
  end
end
