# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Jira < Scenario::Template
            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = QA::Release.new(release)
                gitlab.network = Runtime::Env.docker_network
                gitlab.name = 'gitlab-jira'

                Component::Jira.perform do |jira|
                  jira.network = gitlab.network
                  jira.set_jira_hostname

                  jira.instance do
                    gitlab.instance do
                      Runtime::Logger.info('Running Jira specs!')

                      rspec_args << "--" unless rspec_args.include?('--')
                      rspec_args << "--tag jira"

                      Component::Specs.perform do |specs|
                        specs.suite = 'Test::Instance::All'
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
  end
end
