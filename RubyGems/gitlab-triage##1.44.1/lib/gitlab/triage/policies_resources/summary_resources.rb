# frozen_string_literal: true

require 'delegate'

module Gitlab
  module Triage
    module PoliciesResources
      SummaryResources = Class.new(SimpleDelegator)
    end
  end
end
