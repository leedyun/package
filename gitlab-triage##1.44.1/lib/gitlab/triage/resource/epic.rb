# frozen_string_literal: true

require_relative 'base'
require_relative 'shared/issuable'

module Gitlab
  module Triage
    module Resource
      class Epic < Base
        include Shared::Issuable

        def project_path
          @project_path ||=
            request_group(resource[:group_id])[:full_path]
        end
        alias_method :group_path, :project_path
      end
    end
  end
end
