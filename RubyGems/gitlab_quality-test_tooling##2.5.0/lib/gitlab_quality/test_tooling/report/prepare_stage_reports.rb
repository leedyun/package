# frozen_string_literal: true

require 'nokogiri'

module GitlabQuality
  module TestTooling
    module Report
      class PrepareStageReports
        EXTRACT_STAGE_FROM_TEST_FILE_REGEX = %r{(?:api|browser_ui)/(?:[0-9]+_)?(?<stage>[_\w]+)/}i

        def initialize(input_files:)
          @input_files = input_files
        end

        def invoke!
          collate_test_cases.each do |stage, tests|
            filename = "#{stage}.xml"

            File.write(filename, junit_report(tests).to_s)

            puts "Saved #{filename}"
          end
        end

        private

        attr_reader :input_files

        # Collect the test cases from the original reports and group them by Stage
        def collate_test_cases
          Dir.glob(input_files)
            .each_with_object(Hash.new { |h, k| h[k] = [] }) do |input_file, test_cases|
            report = Nokogiri::XML(File.open(input_file))
            report.xpath('//testcase').each do |test_case|
              # The test file paths could start with any of
              #  /qa/specs/features/api/<stage>
              #  /qa/specs/features/browser_ui/<stage>
              #  /qa/specs/features/ee/api/<stage>
              #  /qa/specs/features/ee/browser_ui/<stage>
              # For now we assume the Stage is whatever follows api/ or browser_ui/
              test_file_match = test_case['file'].match(EXTRACT_STAGE_FROM_TEST_FILE_REGEX)
              next unless test_file_match

              stage = test_file_match[:stage]
              test_cases[stage] << test_case
            end
          end
        end

        def junit_report(test_cases)
          Nokogiri::XML::Document.new.tap do |report|
            test_suite_node = report.create_element('testsuite', name: 'rspec', **collect_stats(test_cases))
            report.root = test_suite_node

            test_cases.each do |test_case|
              test_suite_node.add_child(test_case)
            end
          end
        end

        def collect_stats(test_cases)
          stats = {
            tests: test_cases.size,
            failures: 0,
            errors: 0,
            skipped: 0
          }

          test_cases.each_with_object(stats) do |test_case, memo|
            memo[:failures] += 1 unless test_case.search('failure').empty?
            memo[:errors] += 1 unless test_case.search('error').empty?
            memo[:skipped] += 1 unless test_case.search('skipped').empty?
          end
        end
      end
    end
  end
end
