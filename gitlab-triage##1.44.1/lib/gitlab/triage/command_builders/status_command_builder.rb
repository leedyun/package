# frozen_string_literal: true

require_relative 'base_command_builder'

module Gitlab
  module Triage
    module CommandBuilders
      class StatusCommandBuilder < BaseCommandBuilder
        private

        def separator
          ''
        end

        def slash_command_string
          "/"
        end

        def format_item(item)
          item
        end
      end
    end
  end
end
