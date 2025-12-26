# frozen_string_literal: true

require_relative 'base'
require 'date'
require 'time'

module Gitlab
  module Triage
    module Resource
      class Label < Base
        LabelDoesntExistError = Class.new(StandardError)

        FIELDS = %i[
          id
          project_id
          group_id
          name
          description
          color
          priority
        ].freeze

        TIME_FIELDS = %i[
          added_at
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

        def exist?
          label = network.query_api_cached(resource_url).first
          return false unless label

          label[:name] == name
        end

        private

        def resource_id
          name
        end
      end
    end
  end
end
