# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against staging.gitlab.com (or geo.staging.gitlab.com during failover)
          #
          class Staging < DeploymentBase
            def deployment_component
              Component::Staging
            end

            def non_rspec_args
              if Runtime::Env.geo_failover?
                [deployment_component::GEO_SECONDARY_ADDRESS]
              else
                [deployment_component::ADDRESS]
              end
            end
          end
        end
      end
    end
  end
end
