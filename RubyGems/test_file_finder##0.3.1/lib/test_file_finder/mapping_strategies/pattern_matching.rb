# frozen_string_literal: true

module TestFileFinder
  module MappingStrategies
    class PatternMatching
      attr_reader :pattern_matchers

      def self.load(mapping_file)
        maps = YAML.safe_load_file(mapping_file)['mapping']

        validate(maps)

        new(maps)
      end

      def self.default_rails_mapping
        mapping = new
        mapping.relate(%r{^app/(.+)\.rb$}, 'spec/%s_spec.rb')
        mapping.relate(%r{^lib/(.+)\.rb$}, 'spec/lib/%s_spec.rb')
        mapping.relate(%r{^spec/(.+)_spec\.rb$}, 'spec/%s_spec.rb')
        mapping
      end

      def self.validate(maps = nil)
        raise InvalidMappingFileError, 'missing `mapping` in test mapping file' if maps.nil?

        return if maps.all? { |map| complete?(map) }

        raise InvalidMappingFileError, 'missing `source` or `test` in test mapping file'
      end

      def self.complete?(map)
        !map['source'].nil? && !map['test'].nil?
      end

      def initialize(maps = nil)
        @pattern_matchers = []

        # Useful for the .default_rails_mapping class method
        #
        # We don't have a file to use, but we still need an instance to be returned
        return unless maps

        maps.each do |map|
          Array(map['source']).each do |source|
            Array(map['test']).each do |test|
              relate(source, test)
            end
          end
        end
      end

      def relate(source, test)
        @pattern_matchers << pattern_matcher_for(source, test)
      end

      def match(files)
        @pattern_matchers.inject(Set.new) do |result, pattern_matcher|
          test_files = pattern_matcher.call(files)
          result.merge(test_files)
        end.to_a
      end

      private

      def pattern_matcher_for(source, test)
        regexp = /^#{source}$/

        if regexp.named_captures.any?
          pattern_matcher_with_named_captures_for(regexp, test)
        else
          pattern_matcher_with_numbered_captures_for(regexp, test)
        end
      end

      def pattern_matcher_with_named_captures_for(regexp, test)
        proc do |files|
          Array(files).flat_map do |file|
            match = regexp.match(file)
            format(test, match.named_captures.transform_keys(&:to_sym)) if match
          end.compact
        end
      end

      def pattern_matcher_with_numbered_captures_for(regexp, test)
        proc do |files|
          Array(files).flat_map do |file|
            match = regexp.match(file)
            format(test, *match.captures) if match
          end.compact
        end
      end
    end
  end
end
