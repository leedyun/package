# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class Jira < Base
        DOCKER_IMAGE = 'registry.gitlab.com/gitlab-org/gitlab-qa/jira-gitlab'
        DOCKER_IMAGE_TAG = '8.8-project-and-issue'

        def name
          @name ||= "jira"
        end

        def instance
          raise 'Please provide a block!' unless block_given?

          super
        end

        def start
          docker.run(image: image, tag: tag) do |command|
            command << '-d '
            command << "--name #{name}"
            command << "--net #{network}"
            command << "--hostname #{hostname}"
            command << "--publish 8080:8080"
          end
        end

        def set_jira_hostname
          ::Gitlab::QA::Runtime::Env.jira_hostname = hostname
        end
      end
    end
  end
end
