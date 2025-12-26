# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Report
      # Uses the API to create GitLab issues for any passed test coming from JSON test reports.
      # We expect the test reports to come from a new RSpec process where we retried failing specs.
      #
      # - Takes the JSON test reports like rspec-*.json
      # - Takes a project where flaky test issues should be created
      # - For every passed test in the report:
      #   - Find issue by test hash or create a new issue if no issue was found
      #   - Add a flakiness report in the "Flakiness reports" note
      class FlakyTestIssue < HealthProblemReporter
        IDENTITY_LABELS       = ['test', 'failure::flaky-test', 'test-health:pass-after-retry', 'automation:bot-authored'].freeze
        NEW_ISSUE_LABELS      = Set.new(['type::maintenance', 'priority::3', 'severity::3', *IDENTITY_LABELS]).freeze
        REPORT_SECTION_HEADER = '### Flakiness reports'
        REPORTS_DOCUMENTATION = <<~DOC
          Flaky tests were detected. Please refer to the [Flaky tests reproducibility instructions](https://docs.gitlab.com/ee/development/testing_guide/flaky_tests.html#how-to-reproduce-a-flaky-test-locally)
          to learn more about how to reproduce them.
        DOC

        def initialize(
          base_issue_labels: nil,
          **kwargs)
          super(**kwargs)

          @base_issue_labels = Set.new(base_issue_labels)
        end

        private

        attr_reader :base_issue_labels

        def problem_type
          'flaky'
        end

        def test_is_applicable?(test)
          test.status == 'passed' # We only want failed tests that passed in the end
        end

        def identity_labels
          IDENTITY_LABELS
        end

        def report_section_header
          REPORT_SECTION_HEADER
        end

        def reports_extra_content(_test)
          REPORTS_DOCUMENTATION
        end

        def health_problem_status_label_quick_action(reports_list, **)
          case reports_list.reports_count
          when 399..Float::INFINITY
            '/label ~"flakiness::1"'
          when 37..398
            '/label ~"flakiness::2"'
          when 13..36
            '/label ~"flakiness::3"'
          else
            '/label ~"flakiness::4"'
          end
        end

        def up_to_date_labels(test:, issue: nil, new_labels: Set.new)
          (base_issue_labels + super).to_a
        end
      end
    end
  end
end
