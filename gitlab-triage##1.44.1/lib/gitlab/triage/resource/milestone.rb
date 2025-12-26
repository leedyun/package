# frozen_string_literal: true

require_relative 'base'
require 'date'
require 'time'

module Gitlab
  module Triage
    module Resource
      class Milestone < Base
        FIELDS = %i[
          id
          iid
          project_id
          group_id
          title
          description
          state
        ].freeze

        DATE_FIELDS = %i[
          due_date
          start_date
        ].freeze

        TIME_FIELDS = %i[
          updated_at
          created_at
        ].freeze

        FIELDS.each do |field|
          define_field(field) do
            resource[field]
          end
        end

        DATE_FIELDS.each do |field|
          define_field(field) do
            value = resource[field]

            Date.parse(value) if value
          end
        end

        TIME_FIELDS.each do |field|
          define_field(field) do
            value = resource[field]

            Time.parse(value) if value
          end
        end

        def succ
          index = current_index

          all_active_with_start_date[index.succ] if index
        end

        def active?
          state == 'active'
        end

        def closed?
          state == 'closed'
        end

        def started?(today = Date.today)
          start_date && start_date <= today
        end

        def expired?(today = Date.today)
          due_date && due_date < today
        end

        def in_progress?(today = Date.today)
          started?(today) && !expired?(today)
        end

        private

        def current_index
          all_active_with_start_date
            .index { |milestone| milestone.id == id }
        end

        def all_active_with_start_date
          @all_active_with_start_date ||=
            all_active.select(&:start_date).sort_by(&:start_date)
        end

        def all_active
          @all_active ||=
            network
              .query_api_cached(url(state: 'active'))
              .map { |milestone| self.class.new(milestone, parent: self) }
        end
      end
    end
  end
end
