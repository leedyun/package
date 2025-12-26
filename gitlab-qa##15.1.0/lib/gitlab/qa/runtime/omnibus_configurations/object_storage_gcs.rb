# frozen_string_literal: true

require 'tempfile'

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        class ObjectStorageGcs < Default
          def configuration
            Runtime::Env.require_gcs_environment!

            json_key = setup_json_key

            <<~OMNIBUS
              gitlab_rails['object_store']['connection'] = { 'provider' => 'Google', 'google_project' => '$GOOGLE_PROJECT', 'google_client_email' => '$GOOGLE_CLIENT_EMAIL', 'google_json_key_location' => '#{json_key.path}' }

              gitlab_rails['object_store']['objects']['artifacts']['bucket'] = '#{Runtime::Env.gcs_bucket_name}'
              gitlab_rails['object_store']['objects']['external_diffs']['bucket'] = '#{Runtime::Env.gcs_bucket_name}'
              gitlab_rails['object_store']['objects']['lfs']['bucket'] = '#{Runtime::Env.gcs_bucket_name}'
              gitlab_rails['object_store']['objects']['uploads']['bucket'] = '#{Runtime::Env.gcs_bucket_name}'
              gitlab_rails['object_store']['objects']['packages']['bucket'] = '#{Runtime::Env.gcs_bucket_name}'
              gitlab_rails['object_store']['objects']['dependency_proxy']['bucket'] = '#{Runtime::Env.gcs_bucket_name}'
              gitlab_rails['object_store']['objects']['pages']['bucket'] = '#{Runtime::Env.gcs_bucket_name}'
              gitlab_rails['object_store']['objects']['terraform_state']['bucket'] = '#{Runtime::Env.gcs_bucket_name}'
            OMNIBUS
          end

          def setup_json_key
            Tempfile.open('gcs-json-key', ENV.fetch('CI_PROJECT_DIR', nil)) do |file|
              file.write(ENV.fetch('GOOGLE_JSON_KEY'))

              file
            end
          end
        end
      end
    end
  end
end
