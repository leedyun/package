# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class Praefect < Base
        extend Forwardable
        using Rainbow
        attr_reader :release
        attr_accessor :cluster_config
        attr_writer :name

        def_delegators :release, :tag, :image, :edition

        def initialize
          super
          self.release = 'CE'
          @cluster_config = Component::GitalyCluster::GitalyClusterConfig.new
          @ports = [cluster_config.praefect_port]
        end

        def name
          @name || "praefect-#{SecureRandom.hex(4)}"
        end

        def release=(release)
          @release = QA::Release.new(release)
        end

        def pull
          docker.login(**release.login_params) if release.login_params

          super
        end

        def reconfigure
          setup_omnibus
          @docker.attach(name) do |line|
            # TODO, workaround which allows to detach from the container
            break if line.include?('gitlab Reconfigured!')
          end
        end

        def setup_omnibus
          @docker.write_files(name) do |f|
            f.write('/etc/gitlab/gitlab.rb', praefect_omnibus_configuration)
          end
        end

        def wait_until_ready
          @docker.exec(name, 'praefect -config /var/opt/gitlab/praefect/cluster_config.toml check || true') do |resp|
            Runtime::Logger.info(resp)
            break if line.include?('All checks passed')
          end
        end

        def praefect_omnibus_configuration # rubocop:disable Metrics/AbcSize
          <<~OMNIBUS
              #{GitalyCluster.disable_other_omnibus_services}
              gitaly['enable'] = false;
              prometheus['enable'] = true;
              praefect['enable'] = true;
              praefect['configuration'] = {
                listen_addr: '0.0.0.0:#{cluster_config.praefect_port}',
                prometheus_listen_addr: '0.0.0.0:9652',
                auth: {
                  token: 'PRAEFECT_EXTERNAL_TOKEN'
                },
                reconciliation: {
                  scheduling_interval: '10s'
                },
                database: {
                  host: '#{cluster_config.database_node_addr}',
                  port: #{cluster_config.database_port},
                  user: 'postgres',
                  password: 'SQL_PASSWORD',
                  dbname: 'praefect_production',
                  sslmode: 'disable'
                },
                virtual_storage: [
                  {
                    name: 'default',
                    node: [
                      {
                        'storage': '#{cluster_config.primary_node_name}',
                        'address': 'tcp://#{cluster_config.primary_node_addr}:#{cluster_config.primary_node_port}',
                        'token': 'PRAEFECT_INTERNAL_TOKEN'
                      },
                      {
                        'storage': '#{cluster_config.secondary_node_name}',
                        'address': 'tcp://#{cluster_config.secondary_node_addr}:#{cluster_config.secondary_node_port}',
                        'token': 'PRAEFECT_INTERNAL_TOKEN'
                      },
                      {
                        'storage': '#{cluster_config.tertiary_node_name}',
                        'address': 'tcp://#{cluster_config.tertiary_node_addr}:#{cluster_config.tertiary_node_port}',
                        'token': 'PRAEFECT_INTERNAL_TOKEN'
                      }
                    ],
                  }
                ]
              }
          OMNIBUS
        end
      end
    end
  end
end
