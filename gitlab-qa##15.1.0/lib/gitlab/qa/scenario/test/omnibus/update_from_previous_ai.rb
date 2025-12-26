# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class UpdateFromPreviousAi < UpdateFromPrevious
            def initialize
              Runtime::Env.require_cloud_connector_base_url!
              @use_cloud_license = true
              @perform_license_sync_event = false
              super
            end

            def seeding_suite_args
              super + (rspec_args[1..] || [])
            end

            def pre_seeding_environment_actions(gitlab)
              super
              set_up_gitlab_duo(gitlab)
            end

            private

            def set_up_gitlab_duo(gitlab)
              setup_src_path = File.expand_path('../../../../../../support/setup', __dir__)
              setup_dest_path = '/tmp/setup-scripts'

              Runtime::Logger.info('Setting up Gitlab Duo on GitLab instance')

              gitlab.docker.copy(gitlab.name, setup_src_path, setup_dest_path)

              gitlab.docker.exec(
                gitlab.name,
                "ASSIGN_SEATS=true HAS_ADD_ON=true gitlab-rails runner #{setup_dest_path}/gitlab_duo_setup.rb",
                mask_secrets: gitlab.secrets
              )
            end
          end
        end
      end
    end
  end
end
