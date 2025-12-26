# frozen_string_literal: true

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        class ObjectStorage < Default
          TYPES = %w[artifacts external_diffs lfs uploads packages dependency_proxy terraform_state pages].freeze

          def configuration
            config = TYPES.each_with_object(+'') do |object_type, omnibus|
              omnibus << <<~OMNIBUS
                gitlab_rails['object_store']['objects']['#{object_type}']['bucket'] = '#{object_type}-bucket'
              OMNIBUS
            end
            config << <<~OMNIBUS
              gitlab_rails['object_store']['enabled'] = true
              gitlab_rails['object_store']['proxy_download'] = true
              gitlab_rails['object_store']['connection'] = #{minio.to_config}
            OMNIBUS
          end

          def prepare
            minio.network = Runtime::Env.docker_network

            TYPES.each do |bucket_name|
              minio.add_bucket("#{bucket_name}-bucket")
            end

            minio
          end

          def exec_commands
            QA::Scenario::CLICommands.git_lfs_install_commands
          end

          private

          def minio
            @minio ||= Component::Minio.new
          end
        end
      end
    end
  end
end
