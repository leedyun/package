# frozen_string_literal: true

require 'nokogiri'

module GitlabQuality
  module TestTooling
    module TestResults
      class JUnitTestResults < BaseTestResults
        def write
          # Ignore it for now
        end

        private

        def parse
          Nokogiri::XML.parse(File.read(path))
        end

        def process
          results.xpath('//testcase').map do |test|
            GitlabQuality::TestTooling::TestResult::JUnitTestResult.new(report: test, project: project, token: token)
          end
        end
      end
    end
  end
end
