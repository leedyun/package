# frozen_string_literal: true

require_relative 'base_command_builder'

module Gitlab
  module Triage
    module CommandBuilders
      class RemoveLabelCommandBuilder < LabelCommandBuilder
        private

        def slash_command_string
          '/unlabel'
        end
      end
    end
  end
end
