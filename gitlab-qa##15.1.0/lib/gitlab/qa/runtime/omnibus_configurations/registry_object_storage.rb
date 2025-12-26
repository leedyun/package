# frozen_string_literal: true

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        class RegistryObjectStorage < Default
          def configuration
            Runtime::Env.require_aws_s3_environment!

            <<~OMNIBUS
              registry['storage'] = { 's3' => { 'accesskey' => '$AWS_S3_KEY_ID', 'secretkey' => '$AWS_S3_ACCESS_KEY', 'bucket' => '$AWS_S3_BUCKET_NAME', 'region' => '#{Runtime::Env.aws_s3_region}' } }
            OMNIBUS
          end
        end
      end
    end
  end
end
