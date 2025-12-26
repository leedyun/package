# frozen_string_literal: true

require 'set'
require 'yaml'
require 'test_file_finder/mapping_strategies'

module TestFileFinder
  Mapping = MappingStrategies::PatternMatching
end
