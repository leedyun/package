# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class ServicePingDisabled < Scenario::Template
            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = Runtime::Env.docker_network

                gitlab.omnibus_configuration << <<~OMNIBUS
                  gitlab_rails['usage_ping_enabled'] = false;
                OMNIBUS

                gitlab.instance do
                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Integration::ServicePingDisabled'
                    specs.release = gitlab.release
                    specs.network = gitlab.network
                    specs.args = [gitlab.address, *rspec_args]
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
