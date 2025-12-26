# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class SuggestedReviewer < Scenario::Template
            attr_reader :spec_suite

            def initialize
              @spec_suite = 'Test::Instance::All'
              @network = Runtime::Env.docker_network
              @env = {}
              @tag = 'suggested_reviewer'
              @gitlab_name = 'gitlab-suggested-reviewer'
            end

            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = QA::Release.new(release)
                gitlab.name = @gitlab_name
                gitlab.network = @network

                gitlab.instance do
                  # Wait for the suggested reviewer services to be ready before attempting to run specs
                  @cluster = suggested_reviewer_cluster
                  @cluster.wait_until_ready

                  Runtime::Logger.info('Running Suggested Reviewer specs!')

                  if @tag
                    rspec_args << "--" unless rspec_args.include?('--')
                    rspec_args << "--tag" << @tag
                  end

                  Component::Specs.perform do |specs|
                    specs.suite = spec_suite
                    specs.release = gitlab.release
                    specs.network = gitlab.network
                    specs.args = [gitlab.address, *rspec_args]
                    specs.env = @env
                  end
                end
              end
            ensure
              @cluster&.teardown if @cluster&.teardown?
            end

            def suggested_reviewer_cluster
              Component::SuggestedReviewer.new.tap do |sr|
                sr.prepare
                sr.create_cluster
                sr.deploy_services
              end
            end
          end
        end
      end
    end
  end
end
