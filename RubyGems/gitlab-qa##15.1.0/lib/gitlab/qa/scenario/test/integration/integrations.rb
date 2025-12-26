# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Integrations < Scenario::Template
            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = QA::Release.new(release)
                gitlab.network = Runtime::Env.docker_network
                gitlab.name = 'gitlab-integrations'
                gitlab.instance do
                  Component::Specs.perform do |specs|
                    rspec_args << '--' unless rspec_args.include?('--')
                    rspec_args << "--tag integrations"
                    specs.suite = 'Test::Instance::All'
                    specs.hostname = "qa-e2e-specs.#{gitlab.network}"
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
