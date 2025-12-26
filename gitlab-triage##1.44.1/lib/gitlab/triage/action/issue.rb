# frozen_string_literal: true

require_relative 'base'

module Gitlab
  module Triage
    module Action
      class Issue < Base
        class Dry < Issue
          def act
            puts "The following issues would be created for the rule **#{policy.name}**:\n\n"

            super
          end

          private

          def perform(resource, issue)
            puts ">>>"
            puts "* Project: #{issue.destination || resource[policy.source_id_sym]}"
            puts "* Title: #{issue.title}"
            puts "* Description: #{issue.description}"
            puts ">>>"
          end
        end

        def act
          policy.resources.each do |resource|
            issue = policy.build_issue(resource)

            perform(resource, issue) if issue.valid?
          end
        end

        private

        def perform(resource, issue)
          network.post_api(build_post_url(resource, issue), post_issue_body(issue))
        end

        def build_post_url(resource, issue)
          # POST /projects/:id/issues
          # https://docs.gitlab.com/ee/api/issues.html#new-issue
          post_url = UrlBuilders::UrlBuilder.new(
            network_options: network.options,
            source_id: issue.destination || resource[policy.source_id_sym],
            resource_type: 'issues'
          ).build

          puts Gitlab::Triage::UI.debug "post_issue_url: #{post_url}" if network.options.debug

          post_url
        end

        def post_issue_body(issue)
          {
            title: issue.title,
            description: issue.description
          }
        end
      end
    end
  end
end
