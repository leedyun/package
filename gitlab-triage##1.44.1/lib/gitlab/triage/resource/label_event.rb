# frozen_string_literal: true

require_relative 'base'
require_relative 'label'
require 'date'
require 'time'

module Gitlab
  module Triage
    module Resource
      class LabelEvent < Base
        FIELDS = %i[
          id
          user
          resource_type
          resource_id
          action
        ].freeze

        TIME_FIELDS = %i[
          created_at
        ].freeze

        FIELDS.each do |field|
          define_field(field) do
            resource[field]
          end
        end

        TIME_FIELDS.each do |field|
          define_field(field) do
            value = resource[field]

            Time.parse(value) if value
          end
        end

        def label
          return unless resource[:label]

          @label ||= Label.new(
            resource[:label].reverse_merge(added_at: resource[:created_at]),
            parent: self)
        end
      end
    end
  end
end
