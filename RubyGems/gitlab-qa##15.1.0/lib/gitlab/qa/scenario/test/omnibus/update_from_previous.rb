# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class UpdateFromPrevious < Scenario::Template
            using Rainbow

            attr_reader :rspec_args

            # Test update from N - 1 (major|minor|patch) version to current release
            # Run health check (or smoke if below 17.1.0) test suite on previous release to populate some data in database before update
            #
            # @example
            # perform(gitlab-ee:dev-tag, 15.3.0-pre, major)
            # => will perform upgrades 14.9.5 -> 15.0.5 -> gitlab-ee:dev-tag
            #
            # @param [String] release current release docker image
            # @param [String] current_version current gitlab version associated with docker image
            # @param [String] semver_component semver component for N - 1 version detection, major|minor|patch
            # @param [String] from_edition gitlab edition to update from
            # @param [Array] *rspec_args rspec arguments
            # @return [void]
            def perform(release, current_version, semver_component, from_edition = nil, *rspec_args)
              # When from_edition isn't actually passed but RSpec args arg passed with `-- rspec_args...`,
              # from_edition is wrongly set to `--`, so we fix that here.

              if from_edition == "--"
                rspec_args.prepend('--')
                from_edition = nil
              end

              @current_release = QA::Release.new(release)
              @upgrade_path = Support::GitlabUpgradePath.new(
                current_version,
                semver_component,
                from_edition || @current_release.edition
              ).fetch
              @rspec_args = rspec_args

              upgrade_info = "#{[*upgrade_path, current_release].join(' => ')} (#{current_version})".bright
              Runtime::Logger.info("Performing gitlab update: #{upgrade_info}")

              update(rspec_args)
            end

            def seeding_suite_args
              first_release_version = extract_version(upgrade_path.first.release)
              if Gem::Version.new(first_release_version) < Gem::Version.new("17.1.0")
                ["--", "--tag", "smoke"]
              else
                ["--", "--tag", "health_check"]
              end
            end

            # this is any action or event that may happen before the seeding suite is run
            def pre_seeding_environment_actions(gitlab); end

            private

            attr_reader :current_release, :upgrade_path

            # Extract version number from a string, for example: "gitlab/gitlab-ee:15.11.13-ee.0"
            #
            # @param [String] version_string version string to extract from
            # @return [String] extracted version number
            def extract_version(version_string)
              QA::Release.new(version_string).tag.split('-').first
            end

            # Perform update
            #
            # @param [Array] rspec_args
            # @return [void]
            # rubocop:disable Metrics/AbcSize
            def update(rspec_args)
              Docker::Volumes.new.with_temporary_volumes do |volumes|
                # deploy first release in upgrade path and run specs to populate db
                Runtime::Logger.info("Running the first release in upgrade path: #{upgrade_path.first}")
                run_gitlab(upgrade_path.first, volumes, seeding_suite_args, seeding_run: true)

                # deploy releases in upgrade path
                upgrade_path[1..].each do |release|
                  Runtime::Logger.info("Upgrading GitLab to release: #{release}")
                  run_gitlab(release, volumes, skip_setup: true)
                end

                # deploy current release and run tests
                Runtime::Logger.info("Upgrading GitLab to current release: #{current_release}")
                run_gitlab(current_release, volumes, rspec_args, skip_setup: true)
              end
            end
            # rubocop:enable Metrics/AbcSize

            # Deploy gitlab instance and optionally run specs
            #
            # @param [Gitlab::QA::Release] release
            # @param [Hash] volumes
            # @return [void]
            def run_gitlab(release, volumes, rspec_args = [], skip_setup: false, seeding_run: false) # rubocop:disable Metrics/AbcSize
              Runtime::Logger.info("Deploying release: #{release.to_s.bright}")

              Component::Gitlab.perform do |gitlab|
                gitlab.name = gitlab_name
                gitlab.release = release
                gitlab.volumes = volumes
                gitlab.network = Runtime::Env.docker_network
                gitlab.set_ee_activation_code if @use_cloud_license

                if skip_setup
                  gitlab.skip_server_hooks = true
                  gitlab.seed_db = false
                  gitlab.seed_admin_token = false
                end

                next gitlab.launch_and_teardown_instance unless run_specs?(release)

                gitlab.instance do
                  pre_seeding_environment_actions(gitlab) if seeding_run
                  run_specs(gitlab, release, rspec_args)
                end
              end
            end

            # Run specs
            #
            # @param [Gitlab::QA::Component::Gitlab] gitlab
            # @param [Gitlab::QA::Release] release
            # @param [Array] rspec_args
            # @return [void]
            def run_specs(gitlab, release, rspec_args) # rubocop:disable Metrics/AbcSize
              Runtime::Logger.info("Running test suite to verify update and seed data in environment") unless upgrade_path.first != release
              Runtime::Logger.info("Running test suite to verify update") unless current_release != release

              Component::Specs.perform do |specs|
                specs.release = release
                specs.suite = 'Test::Instance::All'
                specs.hostname = "qa-e2e-specs.#{gitlab.network}"
                specs.network = gitlab.network
                specs.args = [gitlab.address, *rspec_args]
                next if release == current_release

                # do not generate reports and metrics artifacts for non release runs or retry failures
                specs.env = { 'QA_GENERATE_ALLURE_REPORT' => false, 'QA_SAVE_TEST_METRICS' => false }
                specs.retry_failed_specs = false
                # if qa-image was set explicitly, make sure it is not used on initial run for release
                specs.infer_qa_image_from_release = true
              end
            rescue Support::ShellCommand::StatusError => e
              if release == current_release # only fail on current release
                Runtime::Logger.error("Failed to run health check after final upgrade to release '#{release}'")
                raise e
              end

              Runtime::Logger.warn("Health check verification for release '#{gitlab.release}' finished with errors!")
            end

            # Run specs on first release to populate database and release being tested
            #
            # @param [Gitlab::QA::Release] release
            # @return [Boolean]
            def run_specs?(release)
              [upgrade_path.first, current_release].any?(release)
            end

            def gitlab_name
              @gitlab_name ||= "gitlab-updatefromprevious-#{SecureRandom.hex(4)}"
            end
          end
        end
      end
    end
  end
end
