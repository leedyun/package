# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Opensearch < Scenario::Template
            attr_reader :gitlab_name, :spec_suite

            def initialize
              @gitlab_name = 'gitlab-opensearch'
              # Currently the test suite that tests Advanced Search features is called 'Elasticsearch' which we hope to abstract to 'Advancedsearch' in the future
              @spec_suite = 'QA::EE::Scenario::Test::Integration::Elasticsearch'
            end

            def before_perform(release)
              raise ArgumentError, 'OpenSearch is an EE only feature!' unless release.ee?
            end

            def perform(release, *rspec_args)
              release = QA::Release.new(release)
              before_perform(release)

              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                setup_opensearch_on gitlab

                Component::Opensearch.perform do |opensearch|
                  opensearch.network = Runtime::Env.docker_network
                  opensearch.instance do
                    gitlab.instance do
                      Runtime::Logger.info("Running #{spec_suite} specs!")

                      Component::Specs.perform do |specs|
                        specs.suite = spec_suite
                        specs.release = gitlab.release
                        specs.network = gitlab.network
                        specs.args = [gitlab.address, *rspec_args]
                      end
                    end
                  end
                end
              end
            end

            def empty_index
              @empty_index ||= ["gitlab-rake gitlab:elastic:create_empty_index"]
            end

            def setup_opensearch_on(instance)
              instance.name = gitlab_name
              instance.network = Runtime::Env.docker_network
              instance.elastic_url = "http://elastic68:9200"
              instance.exec_commands = empty_index
            end
          end
        end
      end
    end
  end
end
