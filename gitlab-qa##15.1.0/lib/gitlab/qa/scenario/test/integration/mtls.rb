# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class MTLS < Scenario::Template
            def initialize
              @gitlab_name = 'gitlab'
              @gitaly_name = 'gitaly'
              @spec_suite = 'Test::Instance::All'
              @network = Runtime::Env.docker_network
              @env = {}
              @tag = 'mtls'
            end

            def perform(release, *rspec_args)
              gitaly_node = gitaly_node(release)
              gitaly_node.instance(skip_teardown: true)

              Component::Gitlab.perform do |gitlab|
                gitlab.release = QA::Release.new(release)
                gitlab.name = @gitlab_name
                gitlab.network = @network
                gitlab.omnibus_configuration << gitlab_omnibus_config
                gitlab.tls = true

                gitlab.instance do
                  Runtime::Logger.info("Running mTLS specs!")
                  run_mtls_specs(gitlab, *rspec_args)
                end
              end
              gitaly_node.teardown
            end

            private

            def gitaly_node(release)
              Component::Gitlab.new.tap do |gitaly|
                gitaly.release = QA::Release.new(release)
                gitaly.name = @gitaly_name
                gitaly.network = @network
                gitaly.skip_availability_check = true
                gitaly.seed_admin_token = false

                gitaly.omnibus_configuration << gitaly_omnibus_config
                gitaly.gitaly_tls = true
              end
            end

            def run_mtls_specs(gitlab, *rspec_args)
              if @tag
                rspec_args << "--" unless rspec_args.include?('--')
                rspec_args << "--tag" << @tag
              end

              Component::Specs.perform do |specs|
                specs.suite = @spec_suite
                specs.release = gitlab.release
                specs.network = gitlab.network
                specs.args = [gitlab.address, *rspec_args]
                specs.env = @env
              end
            end

            def gitlab_omnibus_config
              <<~OMNIBUS
                gitaly['enable'] = false;

                external_url 'https://#{@gitlab_name}.#{@network}';

                gitlab_rails['gitaly_token'] = 'abc123secret';
                gitlab_shell['secret_token'] = 'shellsecret';

                git_data_dirs({
                  'default' => { 'gitaly_address' => 'tls://#{@gitaly_name}.#{@network}:9999' },
                  'storage1' => { 'gitaly_address' => 'tls://#{@gitaly_name}.#{@network}:9999' },
                });
              OMNIBUS
            end

            def gitaly_omnibus_config
              <<~OMNIBUS
                gitaly['configuration'] = {
                  auth: {
                    token: 'abc123secret',
                  },
                  tls_listen_addr: '0.0.0.0:9999',
                  tls: {
                    certificate_path: '/etc/gitlab/ssl/gitaly.test.crt',
                    key_path: '/etc/gitlab/ssl/gitaly.test.key',
                  },
                  storage: [
                    {
                      name: 'default',
                      path: '/var/opt/gitlab/git-data/repositories',
                    },
                    {
                      name: 'storage1',
                      path: '/mnt/gitlab/git-data/repositories',
                    },
                  ],
                };
                postgresql['enable'] = false;
                redis['enable'] = false;
                nginx['enable'] = false;
                puma['enable'] = false;
                sidekiq['enable'] = false;
                gitlab_workhorse['enable'] = false;
                gitlab_exporter['enable'] = false;
                alertmanager['enable'] = false;
                prometheus['enable'] = false;

                gitlab_rails['rake_cache_clear'] = false;
                gitlab_rails['auto_migrate'] = false;

                gitlab_shell['secret_token'] = 'shellsecret';

                gitlab_rails['internal_api_url'] = 'https://#{@gitlab_name}.#{@network}';

                git_data_dirs({
                  'default' => { 'path' => '/var/opt/gitlab/git-data' },
                  'storage1' => { 'path' => '/mnt/gitlab/git-data' },
                })
              OMNIBUS
            end
          end
        end
      end
    end
  end
end
