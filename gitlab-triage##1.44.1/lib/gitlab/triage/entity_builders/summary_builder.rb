# frozen_string_literal: true

require_relative '../command_builders/text_content_builder'

module Gitlab
  module Triage
    module EntityBuilders
      class SummaryBuilder
        def initialize(
          type:, action:, resources:, network:,
          policy_spec: {}, separator: "\n")
          @type = type
          @policy_spec = policy_spec
          @item_template = action[:item]
          @title_template = action[:title]
          @summary_template = action[:summary]
          @summary_destination = action[:destination]
          @redact_confidentials =
            action[:redact_confidential_resources] != false
          @resources = resources
          @network = network
          @separator = separator
        end

        def title
          @title ||= build_text(title_resource, @title_template)
        end

        def description
          @description ||= build_text(description_resource, @summary_template)
        end

        def destination
          @summary_destination
        end

        def valid?
          title =~ /\S+/ && any_resources?
        end

        def any_resources?
          @resources.any?
        end

        private

        def title_resource
          { type: @type }
        end

        def description_resource
          title_resource.merge(
            title: title, items: items, resources: @resources)
        end

        def items
          @items ||= @resources.map { |x| build_item(x) }.join(@separator)
        end

        def build_item(resource)
          case resource
          when SummaryBuilder
            resource.description
          else
            build_text(resource, @item_template)
          end
        end

        def build_text(resource, template)
          return '' unless template

          CommandBuilders::TextContentBuilder.new(
            template,
            resource: resource,
            network: @network,
            redact_confidentials: @redact_confidentials)
            .build_command.chomp
        end
      end
    end
  end
end
