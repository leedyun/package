# frozen_string_literal: true

require 'mkmf'

module Gitlab
  module QA
    module Service
      class KubernetesCluster
        include Support::Shellout

        attr_reader :provider

        def initialize(provider_class: QA::Service::ClusterProvider::K3d)
          @provider = provider_class.new
        end

        def create!
          validate_dependencies

          @provider.validate_dependencies
          @provider.setup

          self
        end

        def remove!
          @provider.teardown
        end

        def cluster_name
          @provider.cluster_name
        end

        def to_s
          cluster_name
        end

        def create_registry_mirror
          @provider.create_registry_mirror
        end

        def create_secret(secret, secret_name)
          shell("kubectl create secret generic #{secret_name} --from-literal=token='#{secret}'", mask_secrets: [secret])
        end

        def apply_manifest(manifest)
          shell('kubectl apply -f -', stdin_data: manifest)
        end

        private

        def admin_user
          @admin_user ||= "#{@provider.cluster_name}-admin"
        end

        def validate_dependencies
          find_executable('kubectl') || raise("You must first install `kubectl` executable to run these tests.")
        end
      end
    end
  end
end
