# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Report
      # Uses the API to:
      # - create or update test cases
      # - create or update issues
      # based on the results of tests from RSpec run result files.
      class ReportResults < ReportAsIssue
        attr_accessor :testcase_project_reporter, :results_issue_project_reporter, :files, :test_case_project,
          :results_issue_project, :gitlab

        def initialize(
          test_case_project_token:, results_issue_project_token:, input_files:, test_case_project: nil, results_issue_project: nil, dry_run: false,
          **kwargs)
          @test_case_project_token = test_case_project_token
          @testcase_project_reporter = GitlabQuality::TestTooling::Report::ResultsInTestCases.new(
            token: test_case_project_token, input_files: input_files, project: test_case_project, dry_run: dry_run, **kwargs)
          @results_issue_project_reporter = GitlabQuality::TestTooling::Report::ResultsInIssues.new(
            token: results_issue_project_token, input_files: input_files, project: results_issue_project, dry_run: dry_run, **kwargs)
          @test_case_project = test_case_project
          @results_issue_project = results_issue_project
          @files = Array(input_files)
          @gitlab = testcase_project_reporter.gitlab
        end

        def validate_input!
          assert_input_files!(files)
          gitlab.assert_user_permission!
        end

        private

        attr_reader :test_case_project_token

        # rubocop:disable Metrics/AbcSize
        def run!
          puts "Reporting test results in `#{files.join(',')}` as test cases in project `#{test_case_project}` " \
               "and issues in project `#{results_issue_project}` via the API at `#{Runtime::Env.gitlab_api_base}`."

          TestResults::Builder.new(token: test_case_project_token, project: test_case_project, file_glob: files).test_results_per_file do |test_results|
            puts "Reporting tests in #{test_results.path}"

            test_results.each do |test|
              next if test.file.include?('/features/sanity/') || test.skipped?

              puts "Reporting test: #{test.relative_file} | #{test.name}\n"

              report_test(test)
            end

            test_results.write
          end
        end

        def report_test(test)
          testcase = testcase_project_reporter.find_or_create_testcase(test)
          # The API returns the test case with an issue URL since it is technically a type of issue.
          # This updates the URL to a valid test case link.
          test.testcase = testcase.web_url.sub('/issues/', '/quality/test_cases/')

          result_issue, is_new = results_issue_project_reporter.get_related_issue(testcase, test)

          testcase_project_reporter.add_result_issue_link_to_testcase(testcase, result_issue, test) if is_new

          testcase_project_reporter.update_testcase(testcase, test)

          labels_updated = results_issue_project_reporter.update_issue_labels(result_issue, test)
          note_posted = results_issue_project_reporter.post_note(result_issue, test)

          if labels_updated || note_posted
            puts "Issue updated: #{result_issue.web_url}"
          else
            puts "Test passed, no results issue update needed."
          end
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
