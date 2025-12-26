# frozen_string_literal: true

require_relative 'issue'

module Gitlab
  module Triage
    module Resource
      class LinkedIssue < Issue
        def link_type
          @link_type ||= resource.dig(:link_type)
        end
      end
    end
  end
end
