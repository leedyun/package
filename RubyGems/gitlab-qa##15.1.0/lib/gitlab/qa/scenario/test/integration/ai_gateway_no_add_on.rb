# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class AiGatewayNoAddOn < AiGatewayBase
            def initialize
              super
              @tag = 'ai_gateway_no_add_on'
              @has_add_on = false
              @assign_seats = false
            end
          end
        end
      end
    end
  end
end
