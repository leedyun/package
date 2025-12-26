# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Registry < Scenario::Template
            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = Runtime::Env.docker_network
                gitlab.name = 'gitlab'

                gitlab.omnibus_configuration << <<~OMNIBUS
                  external_url 'http://#{gitlab.name}.#{gitlab.network}';
                  registry_external_url 'http://#{gitlab.name}.#{gitlab.network}:5050';
                OMNIBUS

                gitlab.instance do
                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Integration::Registry'
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
