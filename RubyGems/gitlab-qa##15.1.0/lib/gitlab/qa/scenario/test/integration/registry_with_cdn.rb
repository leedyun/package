# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class RegistryWithCDN < Scenario::Template
            def perform(release, *rspec_args)
              Runtime::Env.require_gcs_with_cdn_environment!

              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = Runtime::Env.docker_network
                gitlab.name = 'gitlab'
                gitlab.seed_admin_token = true
                sign_url_key_path = gitlab.create_key_file('GOOGLE_CDN_SIGNURL_KEY')
                cdn_gcloud_path = gitlab.create_key_file('GOOGLE_CDN_JSON_KEY')

                gitlab.omnibus_configuration << <<~OMNIBUS
                  external_url 'http://#{gitlab.name}.#{gitlab.network}';
                  registry_external_url 'http://#{gitlab.name}.#{gitlab.network}:5050';

                  registry['middleware'] = { 'storage' => [{ 'name' => 'googlecdn', 'options' => { 'baseurl' => '#{Runtime::Env.google_cdn_load_balancer}', 'privatekey' => '#{sign_url_key_path}', 'keyname' => '#{Runtime::Env.google_cdn_signurl_key_name}' } }] }
                  registry['storage'] = { 'gcs' => { 'bucket' => '#{Runtime::Env.gcs_cdn_bucket_name}', 'keyfile' => '#{cdn_gcloud_path}' } }
                OMNIBUS

                gitlab.instance do
                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Integration::RegistryWithCDN'
                    specs.release = gitlab.release
                    specs.network = gitlab.network
                    specs.args = [gitlab.address, *rspec_args]
                  end
                ensure
                  gitlab.delete_key_file(sign_url_key_path)
                  gitlab.delete_key_file(cdn_gcloud_path)
                end
              end
            end
          end
        end
      end
    end
  end
end
