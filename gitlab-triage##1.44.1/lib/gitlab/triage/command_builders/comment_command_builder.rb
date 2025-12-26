# frozen_string_literal: true

require_relative 'base_command_builder'

module Gitlab
  module Triage
    module CommandBuilders
      class CommentCommandBuilder < BaseCommandBuilder
        private

        def separator
          "\n\n"
        end

        def format_item(item)
          item
        end
      end
    end
  end
end
