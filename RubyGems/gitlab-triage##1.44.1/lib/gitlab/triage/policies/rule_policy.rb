# frozen_string_literal: true

require_relative 'base_policy'
require_relative '../entity_builders/issue_builder'
require_relative '../entity_builders/summary_builder'

module Gitlab
  module Triage
    module Policies
      class RulePolicy < BasePolicy
        # Build a summary from a single rule policy
        def build_summary
          action = actions.fetch(:summarize, {})

          EntityBuilders::SummaryBuilder.new(
            type: type,
            policy_spec: policy_spec,
            action: action,
            resources: resources,
            network: network)
        end

        def build_issue(resource)
          action = actions.fetch(:issue, {})

          EntityBuilders::IssueBuilder.new(
            type: type,
            policy_spec: policy_spec,
            action: action,
            resource: resource,
            network: network)
        end
      end
    end
  end
end
