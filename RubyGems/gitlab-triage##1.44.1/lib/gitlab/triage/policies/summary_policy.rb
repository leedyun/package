# frozen_string_literal: true

require_relative 'base_policy'
require_relative '../entity_builders/summary_builder'

module Gitlab
  module Triage
    module Policies
      class SummaryPolicy < BasePolicy
        # Build a summary from several rules policies
        def build_summary
          action = actions[:summarize]
          issues = resources.map do |inner_policy_spec, inner_resources|
            Policies::RulePolicy.new(
              type, inner_policy_spec, inner_resources, network)
              .build_summary
          end

          EntityBuilders::SummaryBuilder.new(
            type: type,
            action: action,
            resources: issues.select(&:any_resources?),
            network: network,
            separator: "\n\n")
        end
      end
    end
  end
end
