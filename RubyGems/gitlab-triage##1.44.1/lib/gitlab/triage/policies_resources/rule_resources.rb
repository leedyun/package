# frozen_string_literal: true

require 'delegate'

module Gitlab
  module Triage
    module PoliciesResources
      RuleResources = Class.new(SimpleDelegator)
    end
  end
end
