# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class ClientSSL < Scenario::Template
            def initialize
              @gitlab_name = 'gitlab'
              @spec_suite = 'Test::Instance::All'
              @network = Runtime::Env.docker_network
              @env = {}
              @tag = 'client_ssl'
            end

            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = QA::Release.new(release)
                gitlab.name = @gitlab_name
                gitlab.network = @network
                gitlab.skip_availability_check = true

                gitlab.omnibus_configuration << gitlab_omnibus

                gitlab.tls = true

                gitlab.instance do
                  Runtime::Logger.info('Running Client SSL specs!')

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
              end
            end

            def gitlab_omnibus
              <<~OMNIBUS
                external_url 'https://#{@gitlab_name}.#{@network}';
                letsencrypt['enable'] = false;

                nginx['ssl_certificate'] = '/etc/gitlab/ssl/gitlab.test.crt';
                nginx['ssl_certificate_key'] = '/etc/gitlab/ssl/gitlab.test.key';

                nginx['ssl_verify_client'] = 'on';
                nginx['ssl_client_certificate'] = '/etc/gitlab/trusted-certs/ca.pem';
                nginx['ssl_verify_depth'] = '2';
              OMNIBUS
            end
          end
        end
      end
    end
  end
end
