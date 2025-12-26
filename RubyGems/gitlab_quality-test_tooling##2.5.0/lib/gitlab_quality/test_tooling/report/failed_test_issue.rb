# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Report
      # Uses the API to create GitLab issues for any failed test coming from JSON test reports.
      #
      # - Takes the JSON test reports like rspec-*.json
      # - Takes a project where failed test issues should be created
      # - For every passed test in the report:
      #   - Find issue by test hash or create a new issue if no issue was found
      #   - Add a failure report in the "Failure reports" note
      class FailedTestIssue < HealthProblemReporter
        IDENTITY_LABELS       = ['test', 'test-health:failures', 'automation:bot-authored'].freeze
        NEW_ISSUE_LABELS      = Set.new(['type::maintenance', 'failure::new', 'priority::3', 'severity::3', *IDENTITY_LABELS]).freeze
        REPORT_SECTION_HEADER = '#### Failure reports'

        FAILURE_STACKTRACE_REGEX = %r{(?:(?:.*Failure/Error:(?<stacktrace>.+))|(?<stacktrace>.+))}m
        ISSUE_STACKTRACE_REGEX = /##### Stack trace\s*(```)#{FAILURE_STACKTRACE_REGEX}(```)\n*/m
        DEFAULT_MAX_DIFF_RATIO_FOR_DETECTION = 0.15

        def initialize(
          base_issue_labels: nil,
          max_diff_ratio: DEFAULT_MAX_DIFF_RATIO_FOR_DETECTION,
          **kwargs)
          super(**kwargs)

          @base_issue_labels = Set.new(base_issue_labels)
          @max_diff_ratio = max_diff_ratio.to_f
        end

        def most_recent_report_date_for_issue(issue_iid:)
          reports_discussion = existing_reports_discussion(issue_iid: issue_iid)
          return unless reports_discussion

          # We're skipping the first note of the discussion as this is the "non-collapsible note", aka
          # the "header note", which doesn't contain any stack trace.
          reports_discussion.notes[1..].filter_map do |reports_note|
            most_recent_report_from_reports_note(reports_note)&.report_date
          end.max
        end

        private

        attr_reader :base_issue_labels, :max_diff_ratio

        def problem_type
          'failed'
        end

        # We redefine this method, because we are reporting failed tests in a discussion instead of a comment.
        #
        # We do this because a test could fail for many different reasons, so we report
        # different test failures in the same discussion, under different threads.
        def add_report_to_issue(issue:, test:, related_issues:)
          reports_discussion   = find_or_create_reports_discussion(issue_iid: issue.iid)
          current_reports_note = find_failure_discussion_note(issue: issue, test: test, reports_discussion: reports_discussion)

          new_reports_list = new_reports_list(current_reports_note: current_reports_note, test: test)
          note_body        = new_note_body(
            new_reports_list: new_reports_list,
            related_issues: related_issues,
            options: {
              reports_discussion: reports_discussion,
              test: test
            }
          )

          if current_reports_note
            gitlab.edit_issue_note(
              issue_iid: issue.iid,
              note_id: current_reports_note.id,
              note: note_body
            )
          else
            gitlab.add_note_to_issue_discussion_as_thread(
              iid: issue.iid,
              discussion_id: reports_discussion.id,
              note: note_body
            )
          end
        end

        def find_or_create_reports_discussion(issue_iid:)
          reports_discussion = existing_reports_discussion(issue_iid: issue_iid)
          return reports_discussion if reports_discussion

          gitlab.create_issue_discussion(iid: issue_iid, note: report_section_header)
        end

        def existing_reports_discussion(issue_iid:)
          gitlab.find_issue_discussions(iid: issue_iid).find do |discussion|
            next if discussion.individual_note
            next unless discussion.notes.first

            discussion.notes.first.body.start_with?(report_section_header)
          end
        end

        def test_is_applicable?(test)
          test.status == 'failed'
        end

        def identity_labels
          IDENTITY_LABELS
        end

        def report_section_header
          REPORT_SECTION_HEADER
        end

        def reports_extra_content(test)
          "##### Stack trace\n\n```\n#{test.full_stacktrace}\n```"
        end

        def health_problem_status_label_quick_action(reports_list, options: {})
          quick_actions = []
          quick_actions << '/label ~"priority::1" ~"severity::1"' if reports_list.spiked_in_short_period?

          # We can have several kinds of failures for a single test.
          # We want to count all the failures that are reported for a test.
          reports_notes = options[:reports_discussion].notes[1..] || []
          all_reports_count = reports_notes.sum do |report_note|
            new_reports_list(current_reports_note: report_note, test: options[:test]).reports_count
          end

          quick_actions <<
            case all_reports_count
            when 149..Float::INFINITY
              '/label ~"failed-tests::1"'
            when 137..148
              '/label ~"failed-tests::2"'
            when 130..136
              '/label ~"failed-tests::3"'
            else
              '/label ~"failed-tests::4"'
            end

          quick_actions.join("\n")
        end

        def up_to_date_labels(test:, issue: nil, new_labels: Set.new)
          (base_issue_labels + super).to_a
        end

        def find_failure_discussion_note(issue:, test:, reports_discussion:)
          return unless reports_discussion

          relevant_notes = find_relevant_failure_discussion_note(issue: issue, test: test, reports_discussion: reports_discussion)
          return if relevant_notes.empty?

          best_matching_note, _ = relevant_notes.min_by { |_, diff_ratio| diff_ratio }

          # Re-instantiate a `Gitlab::ObjectifiedHash` object after having converted it to a hash in #find_relevant_failure_issues above.
          best_matching_note = Gitlab::ObjectifiedHash.new(best_matching_note)

          test.failure_issue ||= "#{issue.web_url}#note_#{best_matching_note.id}"

          best_matching_note
        end

        def find_relevant_failure_discussion_note(issue:, test:, reports_discussion:)
          return [] unless reports_discussion.notes.size > 1

          clean_test_stacktrace = cleaned_stack_trace_from_test(test: test)

          # We're skipping the first note of the discussion as this is the "non-collapsible note", aka
          # the "header note", which doesn't contain any stack trace.
          reports_discussion.notes[1..].each_with_object({}) do |note, memo|
            clean_note_stacktrace = cleaned_stack_trace_from_note(issue: issue, note: note)
            diff_ratio = diff_ratio_between_test_and_note_stacktraces(
              issue: issue,
              note: note,
              test_stacktrace: clean_test_stacktrace,
              note_stacktrace: clean_note_stacktrace)

            memo[note.to_h] = diff_ratio if diff_ratio
          end
        end

        def cleaned_stack_trace_from_test(test:)
          sanitize_stacktrace(stacktrace: test.full_stacktrace, regex: FAILURE_STACKTRACE_REGEX) || test.full_stacktrace
        end

        def cleaned_stack_trace_from_note(issue:, note:)
          note_stacktrace = sanitize_stacktrace(stacktrace: note.body, regex: ISSUE_STACKTRACE_REGEX)
          return note_stacktrace if note_stacktrace

          puts "  => [DEBUG] Stacktrace couldn't be found for #{issue.web_url}#note_#{note.id}!"
        end

        def sanitize_stacktrace(stacktrace:, regex:)
          stacktrace_match = stacktrace.match(regex)

          if stacktrace_match
            stacktrace_match[:stacktrace].gsub(/^\s*#.*$/, '').gsub(/^[[:space:]]+/, '').strip
          else
            puts "  => [DEBUG] Stacktrace doesn't match the regex (#{regex})!"
          end
        end

        def diff_ratio_between_test_and_note_stacktraces(issue:, note:, test_stacktrace:, note_stacktrace:)
          return if note_stacktrace.nil?

          stack_trace_comparator = StackTraceComparator.new(test_stacktrace, note_stacktrace)

          if stack_trace_comparator.lower_or_equal_to_diff_ratio?(max_diff_ratio)
            puts "  => [DEBUG] Note #{issue.web_url}#note_#{note.id} has an acceptable diff ratio of #{stack_trace_comparator.diff_percent}%."
            # The `Gitlab::ObjectifiedHash` class overrides `#hash` which is used by `Hash#[]=` to compute the hash key.
            # This leads to a `TypeError Exception: no implicit conversion of Hash into Integer` error, so we convert the object to a hash before using it as a Hash key.
            # See:
            # - https://gitlab.com/gitlab-org/gitlab-qa/-/merge_requests/587#note_453336995
            # - https://github.com/NARKOZ/gitlab/commit/cbdbd1e32623f018a8fae39932a8e3bc4d929abb?_pjax=%23js-repo-pjax-container#r44484494
            stack_trace_comparator.diff_ratio
          else
            puts "  => [DEBUG] Found note #{issue.web_url}#note_#{note.id} but stacktraces are too different (#{stack_trace_comparator.diff_percent}%).\n"
            puts "  => [DEBUG] Issue stacktrace:\n----------------\n#{note_stacktrace}\n----------------\n"
            puts "  => [DEBUG] Failure stacktrace:\n----------------\n#{test_stacktrace}\n----------------\n"
          end
        end
      end
    end
  end
end
