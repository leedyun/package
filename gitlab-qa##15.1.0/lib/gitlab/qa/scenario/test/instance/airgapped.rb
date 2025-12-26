# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          class Airgapped < Scenario::Template
            require 'resolv'
            attr_reader :config, :gitlab_air_gap_commands, :iptables_restricted_network, :airgapped_network_name

            def initialize
              # Uses https://docs.docker.com/engine/reference/commandline/network_create/#network-internal-mode
              @airgapped_network_name = 'airgapped'
              # Uses iptables to deny all network traffic, with a number of exceptions for required ports and IPs
              @iptables_restricted_network = Runtime::Env.docker_network
              @config = Component::GitalyCluster::GitalyClusterConfig.new(
                gitlab_name: "gitlab-airgapped-#{SecureRandom.hex(4)}",
                airgapped_network: true,
                network: airgapped_network_name
              )
            end

            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                Component::GitalyCluster.perform do |cluster|
                  cluster.config = @config
                  cluster.release = release
                  # we need to get an IP for praefect before proceeding so it cannot be run in parallel with gitlab
                  cluster.instance(true).join
                end
                gitlab.name = config.gitlab_name
                gitlab.release = release
                gitlab.network = iptables_restricted_network # we use iptables to restrict access on the gitlab instance
                gitlab.runner_network = config.network
                gitlab.exec_commands = airgap_gitlab_commands
                gitlab.skip_availability_check = true
                gitlab.omnibus_configuration << gitlab_omnibus_configuration
                rspec_args << "--" unless rspec_args.include?('--')
                rspec_args << "--tag ~orchestrated"
                gitlab.instance do
                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Instance::Airgapped'
                    specs.release = gitlab.release
                    specs.network = gitlab.network
                    specs.runner_network = gitlab.runner_network
                    specs.args = [gitlab.address, *rspec_args]
                  end
                end
              end
            end

            private

            def airgap_gitlab_commands
              gitlab_ip = Resolv.getaddress('gitlab.com')
              gitlab_registry_ip = Resolv.getaddress(QA::Release::COM_REGISTRY)
              dev_gitlab_registry_ip = Resolv.getaddress(QA::Release::DEV_REGISTRY.split(':')[0])
              praefect_ip = config.praefect_ip
              @commands = <<~AIRGAP_AND_VERIFY_COMMAND.split(/\n+/)
                # Should not fail before airgapping due to eg. DNS failure
                # Ping and wget check
                apt-get update && apt-get install -y iptables ncat
                if ncat -zv -w 10 #{gitlab_ip} 80; then echo 'Airgapped connectivity check passed.'; else echo 'Airgapped connectivity check failed - should be able to access gitlab_ip'; exit 1; fi;

                echo "Checking regular connectivity..." \
                  && wget --retry-connrefused --waitretry=1 --read-timeout=15 --timeout=10 -t 2 http://registry.gitlab.com > /dev/null 2>&1 \
                  && (echo "Regular connectivity wget check passed." && exit 0) || (echo "Regular connectivity wget check failed." && exit 1)

                iptables -P INPUT DROP && iptables -P OUTPUT DROP
                iptables -A INPUT -i lo -j ACCEPT && iptables -A OUTPUT -o lo -j ACCEPT # LOOPBACK
                iptables -I INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
                iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

                # Jenkins on port 8080 and 50000
                iptables -A OUTPUT -p tcp -m tcp --dport 8080 -m state --state NEW,ESTABLISHED -j ACCEPT \
                  && iptables -A OUTPUT -p tcp -m tcp --dport 50000 -m state --state NEW,ESTABLISHED -j ACCEPT
                iptables -A OUTPUT -p tcp -m tcp --sport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
                iptables -A INPUT -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
                iptables -A OUTPUT -p tcp -m tcp --sport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
                iptables -A INPUT -p tcp -m tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

                # some exceptions to allow runners access network https://gitlab.com/gitlab-org/gitlab-qa/-/issues/700#{' '}
                iptables -A OUTPUT -p tcp -d  #{gitlab_registry_ip} -j ACCEPT
                iptables -A OUTPUT -p tcp -d  #{dev_gitlab_registry_ip} -j ACCEPT
                # allow access to praefect node#{' '}
                iptables -A OUTPUT -p tcp -d #{praefect_ip} -j ACCEPT

                # Should now fail to ping gitlab_ip, port 22/80 should be open
                if ncat -zv -w 10 #{gitlab_ip} 80; then echo 'Airgapped connectivity check failed - should not be able to access gitlab_ip'; exit 1; else echo 'Airgapped connectivity check passed.'; fi;
                if ncat -zv -w 10 127.0.0.1 22; then echo 'Airgapped connectivity port 22 check passed.'; else echo 'Airgapped connectivity port 22 check failed.'; exit 1;  fi;
                if ncat -zv -w 10 127.0.0.1 80; then echo 'Airgapped connectivity port 80 check passed.'; else echo 'Airgapped connectivity port 80 check failed.'; exit 1 ; fi;
                if ncat -zv -w 10 #{gitlab_registry_ip} 80; then echo 'Airgapped connectivity port gitlab_registry_ip check passed.'; else echo 'Airgapped connectivity port 80 check failed.'; exit 1; fi;

                echo "Checking airgapped connectivity..." \
                  && wget --retry-connrefused --waitretry=1 --read-timeout=15 --timeout=10 -t 2 http://registry.gitlab.com > /dev/null 2>&1 \
                  && (echo "Airgapped network faulty. Connectivity wget check failed." && exit 1) || (echo "Airgapped network confirmed. Connectivity wget check passed." && exit 0)
              AIRGAP_AND_VERIFY_COMMAND
            end

            def gitlab_omnibus_configuration
              <<~OMNIBUS
                external_url 'http://#{config.gitlab_name}.#{iptables_restricted_network}';

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
