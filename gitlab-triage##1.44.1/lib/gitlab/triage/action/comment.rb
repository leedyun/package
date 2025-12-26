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
      class Comment < Base
        class Dry < Comment
          def act
            puts "The following comments would be posted for the rule **#{policy.name}**:\n\n"

            super
          end

          private

          def perform(resource, comment)
            puts "# #{resource[:web_url]}\n```\n#{comment}\n```\n"
          end
        end

        def act
          if policy.type == 'branches'
            puts Gitlab::Triage::UI.warn "Comment actions are not available for branches. They will NOT be performed\n\n"
            return
          end

          policy.resources.each do |resource|
            comment = build_comment(resource).strip

            perform(resource, comment) unless comment.empty?
          end
        end

        private

        def build_comment(resource)
          CommandBuilders::CommentCommandBuilder.new(
            [
              CommandBuilders::TextContentBuilder.new(
                policy.actions[:comment],
                resource: resource,
                network: network,
                redact_confidentials: policy.actions.fetch(:redact_confidential_resources, true)
              ).build_command,
              CommandBuilders::LabelCommandBuilder.new(policy.actions[:labels], resource: resource, network: network).build_command,
              CommandBuilders::RemoveLabelCommandBuilder.new(policy.actions[:remove_labels], resource: resource, network: network).build_command,
              CommandBuilders::CcCommandBuilder.new(policy.actions[:mention]).build_command,
              CommandBuilders::MoveCommandBuilder.new(policy.actions[:move]).build_command,
              CommandBuilders::StatusCommandBuilder.new(policy.actions[:status]).build_command
            ]
          ).build_command
        end

        def perform(resource, comment)
          network.post_api(
            build_post_url(resource),
            post_body(comment))
        end

        def build_post_url(resource)
          url_builder_opts = {
            network_options: network.options,
            source: policy.source,
            source_id: resource[policy.source_id_sym],
            resource_type: policy.type,
            resource_id: resource_id(resource),
            sub_resource_type: sub_resource_type
          }

          # POST /(groups|projects)/:id/(epics|issues|merge_requests)/:iid/notes
          post_url = UrlBuilders::UrlBuilder.new(url_builder_opts).build

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

        def resource_id(resource)
          case policy.type
          when 'epics'
            resource['id']
          else
            resource['iid']
          end
        end

        def post_body(comment)
          body = { body: comment }
          body[:internal] = true if policy.actions[:comment_internal]

          body
        end
      end
    end
  end
end
