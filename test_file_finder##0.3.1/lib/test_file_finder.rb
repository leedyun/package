# frozen_string_literal: true

require 'test_file_finder/file_finder'
require 'test_file_finder/mapping'
require 'test_file_finder/mapping_strategies'
require 'test_file_finder/option_parser'
require 'test_file_finder/version'

module TestFileFinder
  Error = Class.new(StandardError)

  InvalidMappingFileError = Class.new(Error)
  TestReportError = Class.new(Error)
end
