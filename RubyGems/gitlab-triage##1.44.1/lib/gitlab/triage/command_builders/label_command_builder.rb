# frozen_string_literal: true

require_relative 'base_command_builder'

module Gitlab
  module Triage
    module CommandBuilders
      class LabelCommandBuilder < BaseCommandBuilder
        def build_command
          ensure_labels_exist!

          super
        end

        private

        def ensure_labels_exist!
          items.each do |label|
            source_id_key = resource.key?(:group_id) ? :group_id : :project_id
            label_opts = {
              source_id_key => resource[source_id_key],
              name: label
            }

            unless Resource::Label.new(label_opts, network: network).exist?
              raise Resource::Label::LabelDoesntExistError,
                "Label `#{label}` doesn't exist!"
            end
          end
        end

        def slash_command_string
          "/label"
        end

        def format_item(item)
          "~\"#{item}\""
        end
      end
    end
  end
end
