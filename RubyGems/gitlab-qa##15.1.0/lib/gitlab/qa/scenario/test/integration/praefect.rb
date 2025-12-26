# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Praefect < GitalyCluster
            attr_reader :gitlab_name, :spec_suite

            def initialize
              super

              @tag = nil
              @env = { QA_PRAEFECT_REPOSITORY_STORAGE: 'default' }
            end

            def gitlab_omnibus_configuration # rubocop:disable Metrics/AbcSize
              <<~OMNIBUS
                external_url 'http://#{config.gitlab_name}.#{config.network}';

                git_data_dirs({
                  'default' => {
                    'gitaly_address' => 'tcp://#{config.praefect_addr}:#{config.praefect_port}',
                    'gitaly_token' => 'PRAEFECT_EXTERNAL_TOKEN'
                  },
                  'gitaly' => {
                    'gitaly_address' => 'tcp://#{config.gitlab_name}.#{config.network}:8075',
                    'path' => '/var/opt/gitlab/git-data'
                  }
                });
                gitaly['enable'] = true;
                gitaly['configuration'] = {
                  auth: {
                    token: 'secret-token',
                  },
                  listen_addr: '0.0.0.0:8075',
                  tls: {
                    certificate_path: '/etc/gitlab/ssl/gitaly.test.crt',
                    key_path: '/etc/gitlab/ssl/gitaly.test.key',
                  },
                  storage: [
                    {
                      name: 'gitaly',
                      path: '/var/opt/gitlab/git-data/repositories',
                    },
                  ],
                };
                gitlab_rails['gitaly_token'] = 'secret-token';
                gitlab_shell['secret_token'] = 'GITLAB_SHELL_SECRET_TOKEN';
                prometheus['scrape_configs'] = [
                  {
                    'job_name' => 'praefect',
                    'static_configs' => [
                      'targets' => [
                        '#{config.praefect_addr}:9652'
                      ]
                    ]
                  },
                  {
                    'job_name' => 'praefect-gitaly',
                    'static_configs' => [
                      'targets' => [
                        '#{config.primary_node_addr}:9236',
                        '#{config.secondary_node_addr}:9236',
                        '#{config.tertiary_node_addr}:9236'
                      ]
                    ]
                  }
                ];
              OMNIBUS
            end
          end
        end
      end
    end
  end
end
