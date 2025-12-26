# frozen_string_literal: true

require 'active_support/core_ext/array/wrap'
require 'cgi'

require_relative 'base_command_builder'
require_relative '../resource/context'

module Gitlab
  module Triage
    module CommandBuilders
      class TextContentBuilder < BaseCommandBuilder
        SUPPORTED_PLACEHOLDERS = {
          created_at: "{{created_at}}",
          updated_at: "{{updated_at}}",
          closed_at: "{{closed_at}}",
          merged_at: "{{merged_at}}",
          state: "{{state}}",
          author: "@{{author.username}}",
          assignee: "@{{assignee.username}}",
          assignees: "@{{assignees.username}}",
          reviewers: "@{{reviewers.username}}",
          source_branch: "{{source_branch}}",
          target_branch: "{{target_branch}}",
          closed_by: "@{{closed_by.username}}",
          merged_by: "@{{merged_by.username}}",
          milestone: %(%"{{milestone.title}}"),
          labels: %(~"{{labels}}"),
          upvotes: "{{upvotes}}",
          downvotes: "{{downvotes}}",
          title: "{{title}}",
          web_url: "{{web_url}}",
          full_reference: "{{references.full}}",
          type: "{{type}}",
          items: "{{items}}",
          name: "{{name}}"
        }.freeze
        PLACEHOLDER_REGEX = /{{([\w.]+)}}/

        def initialize(
          items, resource: nil, network: nil, redact_confidentials: true)
          super(items, resource: resource, network: network)
          @redact_confidentials = redact_confidentials
        end

        private

        def separator
          "\n\n"
        end

        def format_item(item)
          return item unless resource

          replace_placeholders(eval_interpolation(item))
        end

        def eval_interpolation(item)
          quoted_comment = "%Q{#{item}}"

          Resource::Context.build(
            resource,
            network: network,
            redact_confidentials: @redact_confidentials
          ).eval(quoted_comment)
        end

        def replace_placeholders(item)
          SUPPORTED_PLACEHOLDERS.inject(item) do |comment, (placeholder, template)|
            next comment unless comment.include?("{{#{placeholder}}}")

            path = template[/.*#{PLACEHOLDER_REGEX}.*/o, 1]
            attributes = extract_attributes(path)

            formatted_text = attributes.map do |attribute|
              template.sub(PLACEHOLDER_REGEX, attribute.to_s)
            end.join(', ')

            escaped_text =
              case placeholder
              when :items
                # We don't need to escape it because it's recursive,
                # which the contents should all be escaped already.
                # Or put it another way, items isn't an attribute
                # retrieved externally. It's a generated value which
                # should be safe to begin with. At some point we
                # may want to make this more distinguishable,
                # separating values from API and values generated.
                formatted_text
              else
                CGI.escape_html(formatted_text)
              end

            comment.gsub("{{#{placeholder}}}", escaped_text)
          end
        end

        def extract_attributes(path)
          redact_attributes(path, resource_dig_and_map(path.split('.')))
        end

        # If we don't have to map arrays, we can simply do:
        #
        #     resource.dig(*indices)
        #
        # Thus this method name. The only array here is `assignees`
        def resource_dig_and_map(indices)
          attributes = indices.inject(resource) do |result, index|
            break unless result

            case result
            when Array
              result.flat_map { |sub_resource| sub_resource[index] }
            else
              result[index]
            end
          end

          Array.wrap(attributes)
        end

        def redact_attributes(path, attributes)
          return attributes unless redact_confidential_attributes?

          case path
          when 'web_url', 'items', 'type', 'references.full'
            attributes # No need to redact them
          else
            [Resource::Base::CONFIDENTIAL_TEXT]
          end
        end

        def redact_confidential_attributes?
          @redact_confidentials && resource[:confidential]
        end
      end
    end
  end
end
