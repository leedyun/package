# frozen_string_literal: true

require 'rainbow/refinement'
require 'zeitwerk'

module GitlabQuality
  module TestTooling
    Error = Class.new(StandardError)
    loader = Zeitwerk::Loader.new
    loader.push_dir("#{__dir__}/test_tooling", namespace: GitlabQuality::TestTooling)
    loader.ignore("#{__dir__}/test_tooling/version.rb")

    loader.setup
  end
end
