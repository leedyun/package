# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          class RepositoryStorage < Image
            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = QA::Release.new(release)
                gitlab.name = 'gitlab'
                gitlab.network = Runtime::Env.docker_network
                gitlab.omnibus_configuration << gitlab_omnibus_configuration
                cluster = Component::GitalyCluster.perform do |c|
                  c.config = Component::GitalyCluster::GitalyClusterConfig.new(gitlab_name: 'gitlab')
                  c.release = release
                  c.instance
                end

                gitlab.instance do
                  cluster.join

                  rspec_args << "--" unless rspec_args.include?('--')
                  rspec_args << "--tag repository_storage]"

                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Instance::All'
                    specs.release = gitlab.release
                    specs.network = gitlab.network
                    specs.args = [gitlab.address, *rspec_args]
                    specs.env = {
                      'QA_PRAEFECT_REPOSITORY_STORAGE' => 'default',
                      'QA_GITALY_NON_CLUSTER_STORAGE' => 'gitaly',
                      'QA_ADDITIONAL_REPOSITORY_STORAGE' => 'secondary'
                    }
                  end
                end
              end
            end

            private

            def gitlab_omnibus_configuration
              # refer to Gitlab::QA::Component::Praefect and Gitlab::QA::Component::Gitaly
              # for details relating to the default values for tokens/secrets
              <<~OMNIBUS
                external_url 'http://gitlab.test';

                git_data_dirs({
                  'default' => {
                    'gitaly_address' => 'tcp://praefect.test:2305',
                    'gitaly_token' => 'PRAEFECT_EXTERNAL_TOKEN'
                  },
                  'gitaly' => {
                    'gitaly_address' => 'tcp://gitlab.test:8075',
                    'path' => '/var/opt/gitlab/git-data/gitaly'
                  },
                  'secondary' => {
                    'gitaly_address' => 'tcp://gitlab.test:8075',
                    'path' => '/var/opt/gitlab/git-data/secondary'
                  }
                });
                gitaly['enable'] = true;
                gitaly['configuration'] = {
                  auth: {
                    token: 'secret-token',
                  },
                  listen_addr: '0.0.0.0:8075',
                  storage: [
                    {
                      name: 'gitaly',
                      path: '/var/opt/gitlab/git-data/gitaly',
                    },
                    {
                      name: 'secondary',
                      path: '/var/opt/gitlab/git-data/secondary',
                    },
                  ],
                };
                gitlab_rails['gitaly_token'] = 'secret-token';
                gitlab_shell['secret_token'] = 'GITLAB_SHELL_SECRET_TOKEN';
              OMNIBUS
            end
          end
        end
      end
    end
  end
end
