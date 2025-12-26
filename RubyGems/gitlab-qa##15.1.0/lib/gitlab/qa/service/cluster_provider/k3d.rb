# frozen_string_literal: true

module Gitlab
  module QA
    module Service
      module ClusterProvider
        class K3d < Base
          def create_registry_mirror
            return if registry_mirror_exists?('registry-gitlab')

            Runtime::Env.require_qa_container_registry_access_token!

            shell <<~CMD
              k3d registry create registry-gitlab \
                -p 5000 \
                --proxy-remote-url https://#{GITLAB_REGISTRY} \
                --proxy-password #{Runtime::Env.gitlab_username} \
                --proxy-username #{Runtime::Env.qa_container_registry_access_token} \
                -v tmp/registry-gitlab:/var/lib/registry
            CMD

            File.write('tmp/registry-mirror.yml', registry_mirror)

            create_args << %w[--registry-use k3d-registry-gitlab:5000 --registry-config tmp/registry-mirror.yml]
          end

          def validate_dependencies
            find_executable('k3d') || raise("You must first install `k3d` executable to run these tests.")
          end

          def setup
            shell "k3d cluster create #{cluster_name} #{create_args&.join(' ')}"

            install_local_storage
          end

          def teardown
            shell "k3d cluster delete #{cluster_name}"
          end

          private

          def registry_mirror_exists?(name)
            shell('k3d registry list').include?("k3d-#{name}")
          end

          def retry_until(max_attempts: 10, wait: 1)
            max_attempts.times do
              result = yield
              return result if result

              sleep wait
            end

            raise "Retried #{max_attempts} times. Aborting"
          end

          def install_local_storage
            shell('kubectl apply -f -', stdin_data: local_storage_config)
          end

          # See https://github.com/rancher/k3d/issues/67
          def local_storage_config
            <<~YAML
              ---
              apiVersion: v1
              kind: ServiceAccount
              metadata:
                name: storage-provisioner
                namespace: kube-system
              ---
              apiVersion: rbac.authorization.k8s.io/v1
              kind: ClusterRoleBinding
              metadata:
                name: storage-provisioner
              roleRef:
                apiGroup: rbac.authorization.k8s.io
                kind: ClusterRole
                name: system:persistent-volume-provisioner
              subjects:
                - kind: ServiceAccount
                  name: storage-provisioner
                  namespace: kube-system
              ---
              apiVersion: v1
              kind: Pod
              metadata:
                name: storage-provisioner
                namespace: kube-system
              spec:
                serviceAccountName: storage-provisioner
                tolerations:
                - effect: NoExecute
                  key: node.kubernetes.io/not-ready
                  operator: Exists
                  tolerationSeconds: 300
                - effect: NoExecute
                  key: node.kubernetes.io/unreachable
                  operator: Exists
                  tolerationSeconds: 300
                hostNetwork: true
                containers:
                - name: storage-provisioner
                  image: gcr.io/k8s-minikube/storage-provisioner:v1.8.1
                  command: ["/storage-provisioner"]
                  imagePullPolicy: IfNotPresent
                  volumeMounts:
                  - mountPath: /tmp
                    name: tmp
                volumes:
                - name: tmp
                  hostPath:
                    path: /tmp
                    type: Directory
              ---
              kind: StorageClass
              apiVersion: storage.k8s.io/v1
              metadata:
                name: standard
                namespace: kube-system
                annotations:
                  storageclass.kubernetes.io/is-default-class: "true"
                labels:
                  addonmanager.kubernetes.io/mode: EnsureExists
              provisioner: k8s.io/minikube-hostpath
            YAML
          end

          def registry_mirror
            <<~YAML
              mirrors:
                "registry.gitlab.com":
                  endpoint:
                    - http://k3d-registry-gitlab:5000
            YAML
          end
        end
      end
    end
  end
end
