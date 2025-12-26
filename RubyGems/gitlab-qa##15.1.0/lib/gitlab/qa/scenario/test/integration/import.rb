# frozen_string_literal: true

require "parallel"

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          # Scenario type for testing importers
          #
          # In addition to main gitlab instance, starts another gitlab instance to act as source
          #   and mock server to replace all other possible import sources
          #
          class Import < Scenario::Template
            def initialize
              @network = Runtime::Env.docker_network

              @source_gitlab = new_gitlab_instance
              @target_gitlab = new_gitlab_instance
              @mock_server = new_mock_server
              @mail_hog_server = new_mail_hog_server
              @spec_suite = 'Test::Integration::Import'
            end

            attr_reader :source_gitlab, :target_gitlab, :mock_server, :network, :spec_suite, :mail_hog_server

            def configure_omnibus(gitlab, mail_hog)
              raise NotImplementedError
            end

            # Import tests that spins up two gitlab instances
            #
            # @example
            # perform(gitlab-ee, gitlab-ee:17.4.0-ee.0)
            # => will perform import from gitlab-ee:17.4.0-ee.0 to gitlab-ee
            #
            # @param [String] target_release target gitlab instance version release docker image(default)
            # @param [String] source_release source gitlab instance version, if its not passed takes the target release as default
            # @param [Array] *rspec_args rspec arguments
            # @return [void]
            def perform(target_release, source_release = nil, *rspec_args)
              # When source_release isn't actually passed but RSpec args arg passed with `-- rspec_args...`,
              # source_release is wrongly set to `--`, so we fix that here.
              if source_release == "--"
                rspec_args.prepend('--')
                source_release = nil
              end

              source_release = target_release if source_release.nil?
              start_mock_server
              start_gitlab_instances(source_release, target_release)

              run_specs(rspec_args)
            ensure
              mock_server.teardown
              target_gitlab.teardown
              source_gitlab.teardown
            end

            private

            # Initialize a mailhog instance
            #
            # @note this does not start the instance
            # @return [Gitlab::QA::Component::MailHog] Mailhog instance
            def new_mail_hog_server
              Component::MailHog.new.tap do |mail_hog|
                mail_hog.network = @network
                mail_hog.set_mailhog_hostname
              end
            end

            # Check if MailHog server is needed
            #
            # @param [Hash] gitlab_instance
            # @return [Boolean]
            def mail_hog_server_needed?(gitlab_instance)
              respond_to?(:orchestrate_mail_hog_server) && gitlab_instance[:name] == "import-target"
            end

            # Start MailHog server
            #
            # @param [Hash] gitlab_instance
            # @return [void]
            def start_mail_hog_server(gitlab_instance)
              configure_omnibus(gitlab_instance[:instance], mail_hog_server)
              mail_hog_server.start_instance
            end

            # Initialize a mock server instance
            #
            # @note this does not start the instance
            # @return [Gitlab::QA::Component::MockServer] mock server instance
            def new_mock_server
              Component::MockServer.new.tap do |server|
                server.network = @network
                server.tls = true
              end
            end

            # Start mock server instance
            #
            # @return [void]
            def start_mock_server
              mock_server.start_instance
            end

            # Initialize a gitlab instance
            #
            # @note this does not start the instance
            # @return [Gitlab::QA::Component::Gitlab] gitlab instance
            def new_gitlab_instance
              Component::Gitlab.new.tap { |gitlab| gitlab.network = @network }
            end

            # Setup GitLab instance
            #
            # @param [Hash] gitlab_instance
            # @return [void]
            def setup_gitlab_instance(gitlab_instance)
              gitlab_instance[:instance].tap do |gitlab|
                configure_gitlab_instance(gitlab, gitlab_instance)
                start_mail_hog_server(gitlab_instance) if mail_hog_server_needed?(gitlab_instance)
                gitlab.start_instance
              end
            end

            # Configure GitLab instance
            #
            # @param [Gitlab::QA::Component::Gitlab] gitlab
            # @param [Hash] gitlab_instance
            # @return [void]
            def configure_gitlab_instance(gitlab, gitlab_instance)
              gitlab.name = gitlab_instance[:name]
              gitlab.release = gitlab_instance[:release]
              gitlab.additional_hosts = gitlab_instance[:additional_hosts]
              gitlab.seed_admin_token = true
            end

            # Build GitLab instances
            #
            # @param [Gitlab::QA::Release] source_release
            # @param [Gitlab::QA::Release] target_release
            # @return [Array<Hash>]
            def build_gitlab_instances(source_release, target_release)
              [
                { instance: source_gitlab, name: "import-source", additional_hosts: [], release: source_release },
                { instance: target_gitlab, name: "import-target", additional_hosts: mocked_hosts, release: target_release }
              ]
            end

            # Start gitlab instance
            #
            # @param [Gitlab::QA::Release] source_release
            # @param [Gitlab::QA::Release] target_release
            # @return [void]
            def start_gitlab_instances(source_release, target_release)
              instances = build_gitlab_instances(source_release, target_release)

              ::Parallel.each(instances, in_threads: 2) do |gitlab_instance|
                setup_gitlab_instance(gitlab_instance)
              end
            end

            # Run tests
            #
            # @param [Array] rspec_args
            # @return [void]
            def run_specs(rspec_args) # rubocop:disable Metrics/AbcSize
              Runtime::Logger.info("Running #{spec_suite} specs!")

              Component::Specs.perform do |specs|
                specs.suite = spec_suite
                specs.release = target_gitlab.release
                specs.network = network
                specs.args = [target_gitlab.address, *rspec_args]
                specs.env = {
                  "QA_ALLOW_LOCAL_REQUESTS" => "true",
                  "QA_IMPORT_SOURCE_URL" => source_gitlab.address,
                  "QA_SMOCKER_HOST" => mock_server.hostname
                }
              end
            end

            # List of hosts that should be redirected to mock server
            #
            # @return [Array]
            def mocked_hosts
              hosts = []
              hosts << "api.github.com:#{mock_server.ip_address}" if Runtime::Env.mock_github_enabled?

              hosts
            end
          end
        end
      end
    end
  end
end
