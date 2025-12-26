# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Report
      # Uses the API to create GitLab issues for spec run time exceeding Knapsack expectation
      #
      # - Takes the expected and actual Knapsack JSON reports from the knapsack output
      # - Takes a project where issues should be created
      # - For every test file reported with unexpectedly long run time:
      #   - Find issue by test file name, and if found:
      #     - Reopen issue if it already exists, but is closed
      #     - Update the issue with the new run time data
      #   - If not found:
      #     - Create a new issue with the run time data
      class KnapsackReportIssue < ReportAsIssue
        include Concerns::GroupAndCategoryLabels

        NEW_ISSUE_LABELS = Set.new([
          'test', 'automation::bot-authored', 'type::maintenance', 'maintenance::performance',
          'priority::3', 'severity::3', 'knapsack_report'
        ]).freeze
        SEARCH_LABELS = %w[test maintenance::performance knapsack_report].freeze
        JOB_TIMEOUT_EPIC_URL = 'https://gitlab.com/groups/gitlab-org/quality/engineering-productivity/-/epics/19'

        def initialize(token:, input_files:, expected_report:, project: nil, dry_run: false)
          super

          @expected_report = expected_report
        end

        private

        attr_reader :expected_report

        def run!
          puts "Reporting spec file exceeding Knapsack expectaton issues in project `#{project}` via the API at `#{Runtime::Env.gitlab_api_base}`."

          search_and_create_issue
        end

        def search_and_create_issue
          filtered_report = KnapsackReports::SpecRunTimeReport.new(
            token: token,
            project: project,
            expected_report_path: expected_report_path,
            actual_report_path: actual_report_path
          ).filtered_report

          puts "=> Reporting #{filtered_report.count} spec files exceeding Knapsack expectation."

          filtered_report.each do |spec_with_run_time|
            existing_issues = find_issues_for_test(spec_with_run_time, labels: SEARCH_LABELS)

            if existing_issues.empty?
              puts "Creating issue for #{spec_with_run_time.file}"
              create_issue(spec_with_run_time)
            else
              update_issue(issue: existing_issues.last, spec_run_time: spec_with_run_time)
            end
          end
        end

        def expected_report_path
          return if expected_report.nil? || !File.exist?(expected_report)

          expected_report
        end

        def actual_report_path
          return if files.nil? || !File.exist?(files.first)

          files.first
        end

        def new_issue_title(spec_run_time)
          "Job timeout risk: #{spec_run_time.file} ran much longer than expected"
        end

        def new_issue_description(spec_run_time)
          <<~MARKDOWN.chomp
          /epic #{JOB_TIMEOUT_EPIC_URL}

          ### Why was this issue created?

          #{spec_run_time.file_link_markdown} was reported to have:

          1. exceeded Knapsack's expected runtime by at least 50%, and
          2. been identified as a notable pipeline bottleneck and a job timeout risk

          ### Suggested steps for investigation

          1. To reproduce in CI by running test files in the same order, you can follow the steps listed [here](https://docs.gitlab.com/ee/development/testing_guide/flaky_tests.html#recreate-job-failure-in-ci-by-forcing-the-job-to-run-the-same-set-of-test-files).
          1. Identify if a specific test case is stalling the run time. Hint: You can search the job's log for `Starting example group #{spec_run_time.file}` and view the elapsed time after each test case in the proceeding lines starting with `[RSpecRunTime]`.
          1. If the test file is large, consider refactoring it into multiple files to allow better test parallelization across runners.
          1. If the run time cannot be fixed in time, consider quarantine the spec(s) to restore performance.

          ### Run time details

          #{run_time_detail(spec_run_time)}
          MARKDOWN
        end

        def update_issue(issue:, spec_run_time:)
          updated_description = <<~MARKDOWN.chomp
          #{issue.description}

          #{run_time_detail(spec_run_time)}
          MARKDOWN

          issue_attrs = {
            description: updated_description
          }

          # We reopen closed issues to not lose any history
          state_event = issue.state == 'closed' ? 'reopen' : nil
          issue_attrs[:state_event] = state_event if state_event

          gitlab.edit_issue(iid: issue.iid, options: issue_attrs)
          puts "  => Added a report in #{issue.web_url}!"
        end

        def run_time_detail(spec_run_time)
          <<~MARKDOWN.chomp
            - Reported from pipeline #{spec_run_time.ci_pipeline_url_markdown} created at `#{spec_run_time.ci_pipeline_created_at}`

            | Field | Value |
            | ------ | ------ |
            | Job URL| #{spec_run_time.ci_job_link_markdown} |
            | Job total RSpec suite run time | expected: `#{readable_duration(spec_run_time.expected_suite_duration)}`, actual: `#{readable_duration(spec_run_time.actual_suite_duration)}` |
            | Spec file run time | expected: `#{readable_duration(spec_run_time.expected)}`, actual: `#{readable_duration(spec_run_time.actual)}` |
            | Spec file weight | `#{spec_run_time.actual_percentage}%` of total suite run time |
          MARKDOWN
        end

        def assert_input_files!(_files)
          missing_expected_report_msg = "Missing a valid expected Knapsack report."
          missing_actual_report_msg = "Missing a valid actual Knapsack report."

          abort missing_expected_report_msg if expected_report_path.nil?
          abort missing_actual_report_msg if actual_report_path.nil?
        end
      end
    end
  end
end
