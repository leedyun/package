# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class GitlabPages < Scenario::Template
            def initialize
              @gitlab_name = 'gitlab-pages'
              @network = Runtime::Env.docker_network
              @pages_host = 'gitlab-pages.test'
              @pages_sandbox_name = 'gitlab-qa-sandbox-group-pages'
              @tag = 'gitlab_pages'
            end

            def gitlab_omnibus_configuration
              <<~OMNIBUS
                  pages_external_url 'http://#{@gitlab_name}.#{@network}';
                  gitlab_pages['enable'] = true;
              OMNIBUS
            end

            def set_sandbox_name(sandbox_name)
              ::Gitlab::QA::Runtime::Env.gitlab_sandbox_name = sandbox_name
            end

            def perform(release, *rspec_args)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = QA::Release.new(release)
                gitlab.name = @gitlab_name
                gitlab.network = @network

                set_sandbox_name(@pages_sandbox_name)

                gitlab.omnibus_configuration << gitlab_omnibus_configuration
                gitlab.instance do
                  if @tag
                    rspec_args << "--" unless rspec_args.include?('--')
                    rspec_args << "--tag" << @tag
                  end

                  Component::Specs.perform do |specs|
                    specs.additional_hosts << "#{@pages_sandbox_name}.#{@pages_host}:#{gitlab.ip_address}"
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
  end
end
