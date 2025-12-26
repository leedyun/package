# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Geo < Scenario::Template
            # rubocop:disable Lint/MissingCopEnableDirective
            def perform(release, *rspec_args)
              release = QA::Release.new(release)

              raise ArgumentError, 'Geo is EE only!' unless release.ee?

              Runtime::Env.require_license!

              Component::Gitlab.perform do |primary|
                primary.release = release
                primary.name = 'gitlab-primary'
                primary.network = 'geo'
                primary.seed_admin_token = false
                primary.omnibus_configuration << <<~OMNIBUS
                  gitlab_rails['db_key_base'] = '4dd58204865eb41bca93bd38131d51cc';
                  geo_primary_role['enable'] = true;
                  gitlab_rails['db_password'] = 'mypass';
                  gitlab_rails['db_pool'] = 5;
                  gitlab_rails['geo_node_name'] = '#{primary.name}';
                  gitlab_rails['monitoring_whitelist'] = ['0.0.0.0/0'];
                  gitlab_rails['packages_enabled'] = true;
                  postgresql['listen_address'] = '0.0.0.0';
                  postgresql['max_replication_slots'] = 1;
                  postgresql['md5_auth_cidr_addresses'] = ['0.0.0.0/0'];
                  postgresql['sql_user_password'] = 'e1d1469ec5f533651918b4567a3ed1ae';
                  postgresql['trust_auth_cidr_addresses'] = ['0.0.0.0/0','0.0.0.0/0'];
                  sidekiq['concurrency'] = 2;
                  puma['worker_processes'] = 2;
                OMNIBUS
                primary.exec_commands = fast_ssh_key_lookup_commands + QA::Scenario::CLICommands.git_lfs_install_commands

                primary.instance do
                  Component::Gitlab.perform do |secondary|
                    secondary.release = release
                    secondary.name = 'gitlab-secondary'
                    secondary.network = 'geo'
                    secondary.omnibus_configuration << <<~OMNIBUS
                      geo_secondary['db_fdw'] = true;
                      geo_secondary_role['enable'] = true;
                      gitlab_rails['db_key_base'] = '4dd58204865eb41bca93bd38131d51cc';
                      gitlab_rails['db_password'] = 'mypass';
                      gitlab_rails['db_pool'] = 5;
                      gitlab_rails['geo_node_name'] = '#{secondary.name}';
                      gitlab_rails['monitoring_whitelist'] = ['0.0.0.0/0'];
                      gitlab_rails['packages_enabled'] = true;
                      postgresql['listen_address'] = '0.0.0.0';
                      postgresql['md5_auth_cidr_addresses'] = ['0.0.0.0/0'];
                      postgresql['sql_user_password'] = 'e1d1469ec5f533651918b4567a3ed1ae';
                      sidekiq['concurrency'] = 2;
                      puma['worker_processes'] = 2;
                    OMNIBUS
                    secondary.exec_commands += fast_ssh_key_lookup_commands + QA::Scenario::CLICommands.git_lfs_install_commands

                    secondary.act do
                      # TODO, we do not wait for secondary to start because of
                      # https://gitlab.com/gitlab-org/gitlab-ee/issues/3999
                      #
                      # rubocop:disable Style/Semicolon
                      prepare; start; reconfigure; process_exec_commands

                      # shellout to instance specs
                      Runtime::Logger.info('Running Geo primary / secondary specs!')

                      Component::Specs.perform do |specs|
                        specs.suite = 'QA::EE::Scenario::Test::Geo'
                        specs.release = release
                        specs.network = 'geo'
                        specs.args = [
                          '--primary-address', primary.address,
                          '--primary-name', primary.name,
                          '--secondary-address', secondary.address,
                          '--secondary-name', secondary.name,
                          *rspec_args
                        ]
                      end

                      teardown
                    end
                  end
                end
              end
            end

            private

            def fast_ssh_key_lookup_content
              @fast_ssh_key_lookup_content ||= <<~CONTENT
              # Enable fast SSH key lookup - https://docs.gitlab.com/ee/administration/operations/fast_ssh_key_lookup.html
              AuthorizedKeysCommand /opt/gitlab/embedded/service/gitlab-shell/bin/gitlab-shell-authorized-keys-check git %u %k
              AuthorizedKeysCommandUser git
              CONTENT
            end

            def fast_ssh_key_lookup_commands
              @fast_ssh_key_lookup_commands ||= [
                %(echo -e "\n#{fast_ssh_key_lookup_content.chomp}" >> /assets/sshd_config),
                'gitlab-ctl restart sshd'
              ]
            end
          end
        end
      end
    end
  end
end
