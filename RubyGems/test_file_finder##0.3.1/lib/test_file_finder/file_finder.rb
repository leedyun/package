# frozen_string_literal: true

require 'set'

module TestFileFinder
  class FileFinder
    attr_reader :strategies

    def initialize(paths: [])
      @paths = [paths].flatten
      @strategies = []
    end

    def use(strategy)
      @strategies << strategy
    end

    def test_files
      search
    end

    private

    attr_reader :paths

    def search
      file_name_patterns, plain_guesses = file_path_guesses.partition(&file_name_pattern?)

      file_name_patterns.flat_map { |pattern| Dir.glob(pattern) } +
        plain_guesses.select { |path| File.exist?(path) }
    end

    # Returns true if a test file name contains metacharacter like *, {, [, ?
    # which indicates a file name pattern.
    #
    # See https://rubyapi.org/o/dir#method-c-glob
    def file_name_pattern?
      proc { |guess| guess.match?(/[*{\[?]/) }
    end

    def file_path_guesses
      strategies.each_with_object(Set.new) do |strategy, result|
        matches = strategy.match(paths)
        result.merge(matches)
      end
    end
  end
end
