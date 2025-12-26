# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Report
      # Uses the API to create GitLab issues for slow tests
      #
      # - Takes the JSON test reports like rspec-*.json`
      # - Takes a project where slow issues should be created
      # - Find issue by title (with test description or test file)
      # - Add test metadata, duration to the issue with group and category labels
      class SlowTestIssue < HealthProblemReporter
        IDENTITY_LABELS       = ['test', 'rspec:slow test', 'test-health:slow', 'rspec profiling', 'automation:bot-authored'].freeze
        NEW_ISSUE_LABELS      = Set.new(['test', 'type::maintenance', 'maintenance::performance', 'priority::3', 'severity::3', *IDENTITY_LABELS]).freeze
        REPORT_SECTION_HEADER = '### Slowness reports'
        REPORTS_DOCUMENTATION = <<~DOC
          Slow tests were detected, please see the [test speed best practices guide](https://docs.gitlab.com/ee/development/testing_guide/best_practices.html#test-speed)
          to improve them. More context available about this issue in the [top slow tests guide](https://docs.gitlab.com/ee/development/testing_guide/best_practices.html#top-slow-tests).

          Add `allowed_to_be_slow: true` to the RSpec test if this is a legit slow test and close the issue.
        DOC

        private

        def problem_type
          'slow'
        end

        def test_is_applicable?(test)
          test.slow_test?
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
          when 6099..Float::INFINITY
            '/label ~"slowness::1"'
          when 2177..6098
            '/label ~"slowness::2"'
          when 521..2176
            '/label ~"slowness::3"'
          else
            '/label ~"slowness::4"'
          end
        end

        def item_extra_content(test)
          "(#{test.run_time} seconds) #{found_label}"
        end
      end
    end
  end
end
