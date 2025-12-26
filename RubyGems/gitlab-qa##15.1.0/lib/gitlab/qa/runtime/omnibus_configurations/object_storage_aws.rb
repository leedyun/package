# frozen_string_literal: true

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        class ObjectStorageAws < Default
          def configuration
            Runtime::Env.require_aws_s3_environment!

            <<~OMNIBUS
              gitlab_rails['object_store']['enabled'] = true
              gitlab_rails['object_store']['proxy_download'] = false
              gitlab_rails['object_store']['connection'] = { 'provider' => 'AWS', 'region' => '$AWS_S3_REGION', 'aws_access_key_id' => '$AWS_S3_KEY_ID', 'aws_secret_access_key' => '$AWS_S3_ACCESS_KEY' }

              gitlab_rails['object_store']['objects']['artifacts']['bucket'] = '#{Runtime::Env.aws_s3_bucket_name}'
              gitlab_rails['object_store']['objects']['external_diffs']['bucket'] = '#{Runtime::Env.aws_s3_bucket_name}'
              gitlab_rails['object_store']['objects']['lfs']['bucket'] = '#{Runtime::Env.aws_s3_bucket_name}'
              gitlab_rails['object_store']['objects']['uploads']['bucket'] = '#{Runtime::Env.aws_s3_bucket_name}'
              gitlab_rails['object_store']['objects']['packages']['bucket'] = '#{Runtime::Env.aws_s3_bucket_name}'
              gitlab_rails['object_store']['objects']['dependency_proxy']['bucket'] = '#{Runtime::Env.aws_s3_bucket_name}'
              gitlab_rails['object_store']['objects']['pages']['bucket'] = '#{Runtime::Env.aws_s3_bucket_name}'
              gitlab_rails['object_store']['objects']['terraform_state']['bucket'] = '#{Runtime::Env.aws_s3_bucket_name}'
            OMNIBUS
          end
        end
      end
    end
  end
end
