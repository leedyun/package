# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class GitalyCluster < Scenario::Template
            attr_reader :gitlab_name, :spec_suite, :name, :config

            def initialize
              @spec_suite = 'Test::Instance::All'
              @env = {}
              @tag = 'gitaly_cluster'
              @config = Component::GitalyCluster::GitalyClusterConfig.new
            end

            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = QA::Release.new(release)
                gitlab.name = config.gitlab_name
                gitlab.network = config.network
                gitlab.omnibus_configuration << gitlab_omnibus_configuration
                cluster = Component::GitalyCluster.perform do |cluster|
                  cluster.release = release
                  cluster.instance
                end
                gitlab.instance do
                  cluster.join
                  Runtime::Logger.info('Running Gitaly Cluster specs!')

                  if @tag
                    rspec_args << "--" unless rspec_args.include?('--')
                    rspec_args << "--tag" << @tag
                  end

                  Component::Specs.perform do |specs|
                    specs.suite = spec_suite
                    specs.release = gitlab.release
                    specs.network = gitlab.network
                    specs.args = [gitlab.address, *rspec_args]
                    specs.env = @env
                  end
                end
              end
            end

            private

            def gitlab_omnibus_configuration
              <<~OMNIBUS
                external_url 'http://#{config.gitlab_name}.#{config.network}';

                git_data_dirs({
                  'default' => {
                    'gitaly_address' => 'tcp://#{config.praefect_addr}:#{config.praefect_port}',
                    'gitaly_token' => 'PRAEFECT_EXTERNAL_TOKEN'
                  }
                });
                gitaly['enable'] = false;
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
