# frozen_string_literal: true

require_relative '../command_builders/text_content_builder'

module Gitlab
  module Triage
    module EntityBuilders
      class IssueBuilder
        attr_reader :destination

        def initialize(
          type:, action:, resource:, network:,
          policy_spec: {}, separator: "\n")
          @type = type
          @policy_spec = policy_spec
          @item_template = action[:item]
          @title_template = action[:title]
          @description_template = action[:description]
          @destination = action[:destination]
          @redact_confidentials =
            action[:redact_confidential_resources] != false
          @resource = resource
          @network = network
          @separator = separator
        end

        def title
          @title ||= build_text(@title_template)
        end

        def description
          @description ||= build_text(@description_template)
        end

        def valid?
          title =~ /\S+/
        end

        private

        def build_text(template)
          return '' unless template

          CommandBuilders::TextContentBuilder.new(
            template,
            resource: @resource,
            network: @network,
            redact_confidentials: @redact_confidentials)
            .build_command.chomp
        end
      end
    end
  end
end
