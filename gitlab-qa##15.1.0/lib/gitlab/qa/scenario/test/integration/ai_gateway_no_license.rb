# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class AiGatewayNoLicense < AiGatewayBase
            def initialize
              super
              @tag = 'ai_gateway_no_license'
              @use_cloud_license = false
              @assign_seats = false
            end
          end
        end
      end
    end
  end
end
