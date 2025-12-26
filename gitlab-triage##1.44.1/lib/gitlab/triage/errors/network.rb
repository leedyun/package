# frozen_string_literal: true

module Gitlab
  module Triage
    module Errors
      module Network
        InternalServerError = Class.new(StandardError)
        TooManyRequests = Class.new(StandardError)
        UnexpectedResponse = Class.new(StandardError)
      end
    end
  end
end
