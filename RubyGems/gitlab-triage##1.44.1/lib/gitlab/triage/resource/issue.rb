# frozen_string_literal: true

require_relative 'base'
require_relative 'shared/issuable'

module Gitlab
  module Triage
    module Resource
      class Issue < Base
        include Shared::Issuable

        DATE_FIELDS = %i[
          due_date
        ].freeze

        DATE_FIELDS.each do |field|
          define_field(field) do
            value = resource[field]

            Date.parse(value) if value
          end
        end

        def merge_requests_count
          @merge_requests_count ||= resource.dig(:merge_requests_count)
        end

        def related_merge_requests
          @related_merge_requests ||= network.query_api_cached(
            resource_url(sub_resource_type: 'related_merge_requests'))
            .map { |merge_request| MergeRequest.new(merge_request, parent: self) }
        end

        def closed_by
          @closed_by ||= network.query_api_cached(
            resource_url(sub_resource_type: 'closed_by'))
            .map { |merge_request| MergeRequest.new(merge_request, parent: self) }
        end

        def linked_issues
          @linked_issues ||= network.query_api_cached(
            resource_url(sub_resource_type: 'links'))
            .map { |issue| LinkedIssue.new(issue, parent: self) }
        end

        def expired?(today = Date.today)
          due_date && due_date < today
        end
      end
    end
  end
end
