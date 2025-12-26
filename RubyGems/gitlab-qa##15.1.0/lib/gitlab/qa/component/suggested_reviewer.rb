# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class SuggestedReviewer
        include Scenario::Actable

        # Source: https://gitlab.com/gitlab-org/modelops/applied-ml/review-recommender/cluster-management
        MANIFESTS_PATH = File.expand_path('../../../../support/manifests/suggested_reviewer', __dir__)

        def initialize
          @cluster = Service::KubernetesCluster.new(provider_class: Service::ClusterProvider::K3d)
        end

        def name
          @name ||= "suggested_reviewer"
        end

        def prepare
          @cluster.create_registry_mirror
        end

        def create_cluster
          @cluster.create!
        end

        def deploy_services
          Dir.glob(File.join(MANIFESTS_PATH, '**/*')).each do |file|
            Runtime::Logger.info("Applying manifest #{file}")
            @cluster.apply_manifest(File.read(file))
          end
        end

        def teardown
          @cluster.remove!
        end

        def wait_until_ready; end

        def teardown?
          !Runtime::Scenario.attributes.include?(:teardown) || Runtime::Scenario.teardown
        end
      end
    end
  end
end
