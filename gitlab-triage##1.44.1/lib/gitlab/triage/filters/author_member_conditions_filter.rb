# frozen_string_literal: true

require_relative 'member_conditions_filter'

module Gitlab
  module Triage
    module Filters
      class AuthorMemberConditionsFilter < MemberConditionsFilter
        def member_field
          :author
        end
      end
    end
  end
end
