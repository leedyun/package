# frozen_string_literal: true

require_relative 'expand_condition/list'
require_relative 'expand_condition/sequence'

module Gitlab
  module Triage
    module ExpandCondition
      PIPELINE = [
        List,
        Sequence
      ].freeze

      def self.perform(conditions, pipeline = PIPELINE, &block)
        expand([conditions], pipeline).each(&block)
      end

      def self.expand(conditions, pipeline = PIPELINE)
        pipeline.inject(conditions) do |result, job|
          result.flat_map(&job.method(:expand))
        end
      end
    end
  end
end
