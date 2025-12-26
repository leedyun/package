# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          class StagingRefGeo < DeploymentBase
            def initialize
              @suite = 'QA::EE::Scenario::Test::Geo'
            end

            def deployment_component
              Component::StagingRef
            end

            def non_rspec_args
              [
                '--primary-address', deployment_component::ADDRESS,
                '--secondary-address', deployment_component::GEO_SECONDARY_ADDRESS,
                '--without-setup'
              ]
            end
          end
        end
      end
    end
  end
end
