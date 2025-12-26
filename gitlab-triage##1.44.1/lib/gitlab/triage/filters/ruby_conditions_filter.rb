# frozen_string_literal: true

require_relative 'base_conditions_filter'
require_relative '../resource/context'
require 'date'

module Gitlab
  module Triage
    module Filters
      class RubyConditionsFilter < BaseConditionsFilter
        def self.limiter_parameters
          [{ name: :ruby, type: String }]
        end

        def initialize(resource, condition, network = nil)
          super(resource, { ruby: condition })

          @network = network
        end

        def calculate
          context = Resource::Context.build(@resource, network: @network, redact_confidentials: false)

          !!context.eval(@expression)
        end

        private

        def initialize_variables(condition)
          @expression = condition[:ruby]
        end
      end
    end
  end
end
