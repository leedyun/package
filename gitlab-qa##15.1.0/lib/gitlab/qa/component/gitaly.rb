# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class Gitaly < Base
        extend Forwardable
        using Rainbow
        attr_reader :release
        attr_accessor :gitaly_port, :gitlab_name, :cluster_config
        attr_writer :name

        def_delegators :release, :tag, :image, :edition

        def initialize
          super
          self.release = 'CE'
          @cluster_config = Component::GitalyCluster::GitalyClusterConfig.new
          @gitaly_port = 8075
          @ports = [gitaly_port]
        end

        def name
          @name || "gitaly-#{SecureRandom.hex(4)}"
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
          @docker.attach(name) do |line, _wait|
            # TODO, workaround which allows to detach from the container
            break if line.include?('gitlab Reconfigured!')
          end
        end

        def setup_omnibus
          @docker.write_files(name) do |f|
            f.write('/etc/gitlab/gitlab.rb', gitaly_omnibus_configuration)
          end
        end

        def process_exec_commands
          Support::ConfigScripts.add_git_server_hooks(docker, name)

          commands = exec_commands.flatten.uniq
          return if commands.empty?

          Runtime::Logger.info("Running exec_commands...")
          commands.each { |command| docker.exec(name, command) }
        end

        def gitaly_omnibus_configuration
          <<~OMNIBUS
            #{GitalyCluster.disable_other_omnibus_services}
            praefect['enable'] = false;
            prometheus['enable'] = true;
            gitaly['enable'] = true;
            gitaly['configuration'] = {
              'listen_addr': '0.0.0.0:#{gitaly_port}',
              'prometheus_listen_addr': '0.0.0.0:9236',
              'auth_token': 'PRAEFECT_INTERNAL_TOKEN',
              'transactions': {'enabled': #{Runtime::Env.qa_gitaly_transactions_enabled?}}
            }
            gitlab_shell['secret_token'] = 'GITLAB_SHELL_SECRET_TOKEN';
            gitlab_rails['internal_api_url'] = 'http://#{cluster_config.gitlab_name}.#{cluster_config.network}';
            git_data_dirs({
              '#{name}' => {
                'path' => '/var/opt/gitlab/git-data'
              }
            });
          OMNIBUS
        end
      end
    end
  end
end
