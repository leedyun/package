# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          class Image < Scenario::Template
            attr_writer :volumes, :seed_admin_token

            def initialize
              @volumes = {}
              @seed_admin_token = true
            end

            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.volumes = @volumes
                gitlab.network = Runtime::Env.docker_network
                gitlab.name = Runtime::Env.qa_gitlab_hostname
                gitlab.seed_admin_token = @seed_admin_token
                gitlab.tls = Runtime::Env.qa_gitlab_use_tls?

                gitlab.instance do
                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Instance::All'
                    specs.hostname = "qa-e2e-specs.#{gitlab.network}"
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
