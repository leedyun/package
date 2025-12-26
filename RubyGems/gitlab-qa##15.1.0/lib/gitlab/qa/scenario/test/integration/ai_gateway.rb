# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class AiGateway < AiGatewayBase
            def initialize
              super
              @tag = 'ai_gateway'
            end
          end
        end
      end
    end
  end
end
