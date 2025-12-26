# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Metrics < Scenario::Template
            PUMA_METRICS_SERVER_PORT = 8083
            SIDEKIQ_METRICS_SERVER_PORT = 8082

            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = Runtime::Env.docker_network
                gitlab.name = 'gitlab'
                gitlab.ports = [PUMA_METRICS_SERVER_PORT, SIDEKIQ_METRICS_SERVER_PORT]

                gitlab.omnibus_configuration << <<~RUBY
                  puma['exporter_enabled'] = true
                  puma['exporter_address'] = '0.0.0.0'
                  puma['exporter_port'] = #{PUMA_METRICS_SERVER_PORT}
                  sidekiq['metrics_enabled'] = true
                  sidekiq['listen_address'] = '0.0.0.0'
                  sidekiq['listen_port'] = #{SIDEKIQ_METRICS_SERVER_PORT}
                RUBY

                gitlab.instance do
                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Integration::Metrics'
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
