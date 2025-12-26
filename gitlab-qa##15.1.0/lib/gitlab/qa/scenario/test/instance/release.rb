# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against release.gitlab.net
          #
          class Release < DeploymentBase
            def deployment_component
              Component::Release
            end
          end
        end
      end
    end
  end
end
