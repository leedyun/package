# frozen_string_literal: true

require_relative '../version'

module Gitlab
  module Triage
    module NetworkAdapters
      class BaseAdapter
        USER_AGENT = "GitLab Triage #{Gitlab::Triage::VERSION}".freeze

        attr_reader :options

        def initialize(options)
          @options = options
        end
      end
    end
  end
end
