# frozen_string_literal: true

require 'json'

module TestFileFinder
  module MappingStrategies
    class DirectMatching
      JSON_ERROR_MESSAGE = 'json file should contain a json object, with array of test files as the values'

      attr_reader :map, :limit_percentage, :limit_min

      def self.load_json(json_file, **kwargs)
        map = JSON.parse(File.read(json_file))

        validate_map(map)
        validate_params(**kwargs)

        new(map, **kwargs)
      end

      def self.validate_map(map)
        return if map.is_a?(Hash) && map.values.all?(Array)

        raise InvalidMappingFileError, JSON_ERROR_MESSAGE
      end

      def self.validate_params(limit_percentage: nil, limit_min: nil)
        return if limit_percentage.nil?

        limit_percentage_valid = limit_percentage.is_a?(Integer) && (1..100).cover?(limit_percentage)
        raise "Invalid value for limit_percentage: should be an integer between 1 and 100" unless limit_percentage_valid

        limit_min_valid = limit_min.nil? || (limit_min.is_a?(Integer) && limit_min.positive?)
        return if limit_min_valid

        raise "Invalid value for limit_min: should be an integer strictly greater than zero"
      end

      def initialize(map, limit_percentage: nil, limit_min: nil)
        @map              = map
        @limit_percentage = limit_percentage
        @limit_min        = limit_min
      end

      def match(files)
        Array(files).inject(Set.new) do |result, file|
          test_files = @map.fetch(file, [])

          if limit_percentage
            sample_size = ((limit_percentage / 100.0) * test_files.count).round
            sample_size = limit_min if limit_min && sample_size <= limit_min

            test_files = test_files.sample(sample_size)
          end

          result.merge(test_files)
        end.to_a
      end
    end
  end
end
