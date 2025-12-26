# frozen_string_literal: true

module Gitlab
  module QA
    module Service
      module ClusterProvider
        class Base
          include Support::Shellout

          GITLAB_REGISTRY = 'registry.gitlab.com'

          attr_accessor :create_args

          def cluster_name
            @cluster_name ||= "qa-cluster-#{Time.now.utc.strftime('%Y%m%d')}-#{SecureRandom.hex(4)}"
          end

          def validate_dependencies
            raise NotImplementedError
          end

          def setup
            raise NotImplementedError
          end

          def teardown
            raise NotImplementedError
          end
        end
      end
    end
  end
end
