# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against Staging Ref environment
          #
          class StagingRef < DeploymentBase
            def deployment_component
              Component::StagingRef
            end
          end
        end
      end
    end
  end
end
