# frozen_string_literal: true

require_relative 'expansion'

module Gitlab
  module Triage
    module ExpandCondition
      module List
        PATTERN = /\{.+?,.+?\}/m

        def self.expand(conditions)
          labels = conditions[:labels]

          return conditions unless labels

          expansion = Expansion.new(PATTERN) do |list|
            list.gsub(/\{|\}/, '').split(',').map(&:strip)
          end

          expansion.perform(labels).map do |new_labels|
            conditions.merge(labels: new_labels)
          end
        end
      end
    end
  end
end
