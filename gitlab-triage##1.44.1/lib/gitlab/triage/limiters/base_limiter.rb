# frozen_string_literal: true

require 'active_support/all'

module Gitlab
  module Triage
    module Limiters
      class BaseLimiter
        def initialize(resources, limit)
          @resources = initialize_resources(resources)
          validate_limit(limit)
          initialize_variables(limit)
        end

        def limit
          raise NotImplementedError
        end

        def self.limiter_parameters
          []
        end

        private

        def initialize_variables(limit); end

        def initialize_resources(resources)
          resources
        end

        def validate_limit(limit)
          LimiterValidator.new(self.class.limiter_parameters, limit).validate!
        end
      end
    end
  end
end
