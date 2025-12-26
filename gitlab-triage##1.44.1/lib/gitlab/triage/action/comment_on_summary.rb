# frozen_string_literal: true

require_relative 'base'
require_relative '../command_builders/text_content_builder'
require_relative '../command_builders/comment_command_builder'
require_relative '../command_builders/label_command_builder'
require_relative '../command_builders/remove_label_command_builder'
require_relative '../command_builders/cc_command_builder'
require_relative '../command_builders/status_command_builder'
require_relative '../command_builders/move_command_builder'

module Gitlab
  module Triage
    module Action
      class CommentOnSummary < Base
        class Dry < CommentOnSummary
          def act
            puts "The following comments would be posted for the rule **#{policy.name}**:\n\n"

            super
          end

          private

          def perform(comment)
            puts "# #{summary[:web_url]}\n```\n#{comment}\n```\n"
          end
        end

        attr_reader :summary

        def initialize(policy:, network:)
          super(policy: policy, network: network)
          @summary = policy.summary
        end

        def act
          policy.resources.each do |resource|
            comment = build_comment(resource).strip

            perform(comment) unless comment.empty?
          end
        end

        private

        def build_comment(resource)
          CommandBuilders::TextContentBuilder.new(policy.actions[:comment_on_summary], resource: resource, network: network).build_command
        end

        def perform(comment)
          network.post_api(build_post_url, body: comment)
        end

        def build_post_url
          # POST /projects/:id/issues/:issue_iid/notes
          post_url = UrlBuilders::UrlBuilder.new(
            network_options: network.options,
            source_id: summary['project_id'],
            resource_type: policy.type,
            resource_id: summary['iid'],
            sub_resource_type: sub_resource_type
          ).build

          puts Gitlab::Triage::UI.debug "post_url: #{post_url}" if network.options.debug

          post_url
        end

        def sub_resource_type
          case type = policy.actions[:comment_type]
          when 'comment', nil # nil is default
            'notes'
          when 'thread'
            'discussions'
          else
            raise ArgumentError, "Unknown comment type: #{type}"
          end
        end
      end
    end
  end
end
