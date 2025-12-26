# frozen_string_literal: true

module Gitlab
  module Triage
    module CommandBuilders
      class BaseCommandBuilder
        def initialize(items, resource: nil, network: nil)
          @items = Array.wrap(items)
          @items.delete('')
          @resource = resource&.with_indifferent_access
          @network = network
        end

        def build_command
          if items.any?
            [slash_command_string, content_string].compact.join(separator)
          else
            ""
          end
        end

        private

        attr_reader :items, :resource, :network

        def separator
          ' '
        end

        def slash_command_string
          nil
        end

        def content_string
          items.map do |item|
            format_item(item)
          end.join(separator)
        end
      end
    end
  end
end
