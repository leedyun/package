# frozen_string_literal: true

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        # Default Configuration for Omnibus
        # All runs will include this configuration
        class Default < Runtime::OmnibusConfiguration
          def configuration
            <<~OMNIBUS
              gitlab_rails['gitlab_default_theme'] = 10 # Light Red Theme
              gitlab_rails['gitlab_disable_animations'] = true # Disable animations
              gitlab_rails['application_settings_cache_seconds'] = 0 # Settings cache expiry
              gitlab_rails['initial_root_password'] = '#{Runtime::Env.admin_password}' # Initial root password
            OMNIBUS
          end

          def self.configuration
            new.configuration
          end
        end
      end
    end
  end
end
