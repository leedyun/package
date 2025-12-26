# frozen_string_literal: true

require_relative 'base'
require_relative 'shared/issuable'

module Gitlab
  module Triage
    module Resource
      class MergeRequest < Base
        include Shared::Issuable

        def first_contribution?
          if resource.key?(:first_contribution)
            resource[:first_contribution]
          else
            expanded = expand_resource!
            expanded[:first_contribution]
          end
        end

        def closes_issues
          @closes_issues ||= network.query_api_cached(
            resource_url(sub_resource_type: 'closes_issues'))
            .map { |issue| Issue.new(issue, parent: self) }
        end
      end
    end
  end
end
