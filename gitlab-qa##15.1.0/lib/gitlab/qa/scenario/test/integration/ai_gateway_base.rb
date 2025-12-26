# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class AiGatewayBase < Scenario::Template
            SETUP_SRC_PATH = File.expand_path('../../../../../../support/setup', __dir__)
            SETUP_DEST_PATH = '/tmp/setup-scripts'

            def initialize
              @network = Runtime::Env.docker_network
              @ai_gateway_name = 'ai-gateway'
              @ai_gateway_hostname = "#{@ai_gateway_name}.#{@network}"
              @ai_gateway_port = 5000
              @use_cloud_license = true
              @has_add_on = true
              @assign_seats = true
            end

            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                set_up_gitlab(gitlab, release)

                Component::AiGateway.perform do |ai_gateway|
                  set_up_ai_gateway(ai_gateway, gitlab_hostname: gitlab.hostname)

                  ai_gateway.instance do
                    gitlab.instance do
                      set_up_gitlab_duo(gitlab) if @use_cloud_license
                      run_specs(gitlab, *rspec_args)
                    end
                  end
                end
              end
            end

            def set_up_gitlab(gitlab, release)
              gitlab.release = QA::Release.new(release)
              gitlab.name = 'gitlab'
              gitlab.network = @network

              gitlab.omnibus_gitlab_rails_env['AI_GATEWAY_URL'] = "http://#{@ai_gateway_hostname}:#{@ai_gateway_port}"
              gitlab.omnibus_gitlab_rails_env['LLM_DEBUG'] = 'true'

              gitlab.set_ee_activation_code if @use_cloud_license
            end

            def set_up_ai_gateway(ai_gateway, gitlab_hostname:)
              ai_gateway.name = @ai_gateway_name
              ai_gateway.network = @network
              ai_gateway.ports = [@ai_gateway_port]

              ai_gateway.configure_environment(gitlab_hostname: gitlab_hostname)
            end

            def set_up_gitlab_duo(gitlab)
              Runtime::Logger.info('Setting up Gitlab Duo on GitLab instance')

              gitlab.docker.copy(gitlab.name, SETUP_SRC_PATH, SETUP_DEST_PATH)

              gitlab.docker.exec(
                gitlab.name,
                "ASSIGN_SEATS=#{@assign_seats} HAS_ADD_ON=#{@has_add_on} gitlab-rails runner #{SETUP_DEST_PATH}/gitlab_duo_setup.rb",
                mask_secrets: gitlab.secrets
              )
            end

            def run_specs(gitlab, *rspec_args)
              Runtime::Logger.info('Running AI Gateway specs!')

              rspec_args << "--" unless rspec_args.include?('--')
              rspec_args << "--tag" << @tag

              Component::Specs.perform do |specs|
                specs.suite = 'Test::Instance::All'
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
