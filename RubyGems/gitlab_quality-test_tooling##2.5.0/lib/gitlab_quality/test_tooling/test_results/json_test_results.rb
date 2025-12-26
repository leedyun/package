# frozen_string_literal: true

require 'json'

module GitlabQuality
  module TestTooling
    module TestResults
      class JsonTestResults < BaseTestResults
        def write
          json = results.merge('examples' => testcases.map(&:report))

          File.write(path, JSON.pretty_generate(json))
        end

        private

        def parse
          JSON.parse(File.read(path))
        rescue JSON::ParserError
          Runtime::Logger.debug("#{self.class.name}##{__method__} attempted to parse invalid JSON at path: #{path}")
          {}
        end

        def process
          return [] if results.empty?

          results['examples'].map do |test|
            GitlabQuality::TestTooling::TestResult::JsonTestResult.new(report: test, project: project, token: token)
          end
        end
      end
    end
  end
end
