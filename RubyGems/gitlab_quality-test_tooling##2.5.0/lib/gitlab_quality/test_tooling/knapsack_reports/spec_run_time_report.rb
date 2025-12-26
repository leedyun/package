# frozen_string_literal: true

require 'json'

module GitlabQuality
  module TestTooling
    module KnapsackReports
      class SpecRunTimeReport
        attr_reader :project, :expected_report, :actual_report

        def initialize(project:, expected_report_path:, actual_report_path:, token: '')
          @project = project
          @expected_report = parse(expected_report_path)
          @actual_report = parse(actual_report_path)
          @token = token
        end

        def filtered_report
          @filtered_report = actual_report.keys.filter_map do |spec_file|
            expected_run_time = expected_report[spec_file]
            actual_run_time = actual_report[spec_file]

            if expected_run_time.nil?
              puts "#{spec_file} missing from the expected Knapsack report, skipping."
              next
            end

            spec_run_time = SpecRunTime.new(
              token: token,
              project: project,
              file: spec_file,
              expected: expected_run_time,
              actual: actual_run_time,
              expected_suite_duration: expected_test_suite_run_time_total,
              actual_suite_duration: actual_test_suite_run_time_total
            )

            spec_run_time if spec_run_time.should_report?
          end
        end

        private

        attr_reader :token

        def parse(report_path)
          JSON.parse(File.read(report_path))
        end

        def expected_test_suite_run_time_total
          @expected_test_suite_run_time_total ||=
            expected_report.reduce(0) do |total_run_time, (_spec_file, run_time)|
              total_run_time + run_time
            end
        end

        def actual_test_suite_run_time_total
          @actual_test_suite_run_time_total ||=
            actual_report.reduce(0) do |total_run_time, (_spec_file, run_time)|
              total_run_time + run_time
            end
        end
      end
    end
  end
end
