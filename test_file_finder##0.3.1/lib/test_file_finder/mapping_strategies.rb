# frozen_string_literal: true

module TestFileFinder
  module MappingStrategies
    autoload :DirectMatching, 'test_file_finder/mapping_strategies/direct_matching'
    autoload :PatternMatching, 'test_file_finder/mapping_strategies/pattern_matching'
    autoload :GitlabMergeRequestRspecFailure, 'test_file_finder/mapping_strategies/gitlab_merge_request_rspec_failure'
  end
end
