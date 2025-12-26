# frozen_string_literal: true

require_relative 'member_conditions_filter'

module Gitlab
  module Triage
    module Filters
      class AssigneeMemberConditionsFilter < MemberConditionsFilter
        def member_field
          :assignee
        end
      end
    end
  end
end
