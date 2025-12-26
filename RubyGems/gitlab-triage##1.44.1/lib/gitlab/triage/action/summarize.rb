# frozen_string_literal: true

require_relative 'base'

module Gitlab
  module Triage
    module Action
      class Summarize < Base
        class Dry < Summarize
          private

          def perform
            policy.summary = {
              web_url: '[the-created-issue-url]',
              project_id: 'some-id',
              iid: 'some-iid'
            }.with_indifferent_access

            if group_summary_without_destination?
              puts Gitlab::Triage::UI.warn("No issue will be created: No summary destination specified when source is 'groups'.")
              return
            end

            puts "The following issue would be created in project `#{destination}` for the rule **#{policy.name}**:\n\n"
            puts ">>>"
            puts "* Title: #{issue.title}"
            puts "* Description: #{issue.description}"
            puts ">>>"
          end
        end

        def act
          perform if issue.valid?
        end

        private

        def perform
          if group_summary_without_destination?
            puts Gitlab::Triage::UI.warn("Issue was not created: No summary destination specified when source is 'groups'.")
            return
          end

          policy.summary = network.post_api(post_issue_url, post_issue_body)
        end

        def issue
          @issue ||= policy.build_summary
        end

        def destination
          issue.destination || network.options.source_id
        end

        def group_summary_without_destination?
          network.options.source == :groups && !issue.destination
        end

        def post_issue_url
          # POST /projects/:id/issues
          # https://docs.gitlab.com/ee/api/issues.html#new-issue
          post_url = UrlBuilders::UrlBuilder.new(
            network_options: network.options,
            source_id: destination,
            resource_type: 'issues'
          ).build

          puts Gitlab::Triage::UI.debug "post_issue_url: #{post_url}" if network.options.debug

          post_url
        end

        def post_issue_body
          {
            title: issue.title,
            description: issue.description
          }
        end
      end
    end
  end
end
