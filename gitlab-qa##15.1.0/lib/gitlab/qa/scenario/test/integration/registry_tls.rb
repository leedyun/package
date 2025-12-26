# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class RegistryTLS < Scenario::Template
            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = Runtime::Env.docker_network
                gitlab.name = 'gitlab'
                gitlab.tls = true

                gitlab.omnibus_configuration << <<~OMNIBUS
                  external_url 'https://#{gitlab.name}.#{gitlab.network}';
                  registry_external_url 'https://#{gitlab.name}.#{gitlab.network}:5050';

                  letsencrypt['enable'] = false;

                  nginx['redirect_http_to_https'] = true;
                  nginx['ssl_certificate'] = "/etc/gitlab/ssl/gitlab.test.crt";
                  nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/gitlab.test.key";
                  registry_nginx['ssl_certificate'] = "/etc/gitlab/ssl/gitlab.test.crt";
                  registry_nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/gitlab.test.key";
                OMNIBUS

                gitlab.instance do
                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Integration::RegistryTLS'
                    specs.release = gitlab.release
                    specs.network = gitlab.network
                    specs.args = [gitlab.address, *rspec_args]
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
