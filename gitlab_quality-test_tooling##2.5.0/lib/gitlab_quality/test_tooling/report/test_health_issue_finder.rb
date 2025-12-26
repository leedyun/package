# frozen_string_literal: true

require 'http'
require 'json'

module GitlabQuality
  module TestTooling
    module Report
      class TestHealthIssueFinder < ReportAsIssue
        HEALTH_PROBLEM_TYPE_TO_LABEL = {
          'pass-after-retry' => 'test-health:pass-after-retry',
          'slow' => 'test-health:slow',
          'failures' => 'test-health:failures'
        }.freeze

        def initialize(health_problem_type: [], **kwargs)
          super(**kwargs)

          @health_problem_type = health_problem_type
        end

        def found_existing_unhealthy_test_issue?
          issue_url = invoke!

          !issue_url.nil? && !issue_url.empty?
        end

        def run!
          existing_issue_found = nil

          applicable_tests.each do |test|
            issues = find_issues_by_hash(test_hash(test), state: 'opened', labels: search_labels)
            next if issues.empty?

            existing_issue_found = issues.first.web_url
            puts "Found an existing test health issue of type #{health_problem_type} for test #{test.file}:#{test.line_number}: #{existing_issue_found}."
            break
          end

          puts "Did not find an existing test health issue of type #{health_problem_type}." unless existing_issue_found

          existing_issue_found
        end

        def applicable_tests
          applicable_tests = []

          TestResults::Builder.new(file_glob: files, token: token, project: project).test_results_per_file do |test_results|
            applicable_tests = test_results.select { |test| test_is_applicable?(test) }
          end

          applicable_tests
        end

        private

        attr_reader :health_problem_type

        # Be mindful about the number of tests this method would return,
        # as we will make at least one API request per test.
        def test_is_applicable?(test)
          expected_test_status =
            case health_problem_type
            when 'failures'
              'failed'
            else
              'passed'
            end

          test.status == expected_test_status
        end

        def search_labels
          ['test', HEALTH_PROBLEM_TYPE_TO_LABEL[health_problem_type]]
        end
      end
    end
  end
end
