# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class AiGatewayNoSeatAssigned < AiGatewayBase
            def initialize
              super
              @tag = 'ai_gateway_no_seat_assigned'
              @assign_seats = false
            end
          end
        end
      end
    end
  end
end
