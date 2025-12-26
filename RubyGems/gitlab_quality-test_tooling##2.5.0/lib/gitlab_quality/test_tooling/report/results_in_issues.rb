# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Report
      # Uses the API to create or update GitLab test result issues with the results of tests from RSpec report files.
      class ResultsInIssues < ReportAsIssue
        include Concerns::ResultsReporter

        def initialize(**kwargs)
          super
          @issue_type = 'issue'
        end

        def get_related_issue(testcase, test)
          issue = find_linked_results_issue_by_iid(testcase, test)
          is_new = false

          if issue
            issue = update_issue(issue, test) if issue_title_needs_updating?(issue, test)
          else
            puts "No valid issue link found."
            issue = find_or_create_results_issue(test)
            is_new = true
          end

          [issue, is_new]
        end

        def update_issue_labels(issue, test)
          new_labels = issue_labels(issue)
          new_labels |= ['Testcase Linked']

          update_labels(issue, test, new_labels)
        end

        def post_note(issue, test)
          return false if test.skipped?
          return false if test.failures.empty?

          note = note_content(test)

          gitlab.find_issue_discussions(iid: issue.iid).each do |discussion|
            next unless new_note_matches_discussion?(note, discussion)

            gitlab.add_note_to_issue_discussion_as_thread(
              iid: issue.iid,
              discussion_id: discussion.id,
              note: failure_summary)
            return true
          end

          gitlab.create_issue_note(iid: issue.iid, note: note)
        end

        private

        def find_linked_results_issue_by_iid(testcase, _test)
          iid = issue_iid_from_testcase(testcase)

          return unless iid

          find_issue_by_iid(iid)
        end

        def find_or_create_results_issue(test)
          find_issue(test) || create_issue(test)
        end

        def issue_iid_from_testcase(testcase)
          results = testcase.description.partition(TEST_CASE_RESULTS_SECTION_TEMPLATE).last if testcase.description.include?(TEST_CASE_RESULTS_SECTION_TEMPLATE)

          return unless results

          issue_iid = results.split('/').last

          issue_iid&.to_i
        end

        def note_content(test)
          errors = test.failures.each_with_object([]) do |failure, text|
            text << <<~TEXT
              Error:
              ```
              #{failure['message']}
              ```

              Stacktrace:
              ```
              #{failure['stacktrace']}
              ```
            TEXT
          end.join("\n\n")

          "#{failure_summary}\n\n#{errors}"
        end

        def failure_summary
          summary = [%(:x: ~"#{pipeline}::failed")]
          summary << "in job `#{Runtime::Env.ci_job_name}` in #{Runtime::Env.ci_job_url}"
          summary.join(' ')
        end

        def new_note_matches_discussion?(note, discussion)
          note_error = error_and_stack_trace(note)
          discussion_error = error_and_stack_trace(discussion.notes.first['body'])

          return false if note_error.empty? || discussion_error.empty?

          note_error == discussion_error
        end

        def error_and_stack_trace(text)
          text.strip[/Error:(.*)/m, 1].to_s
        end

        def updated_description(_issue, test)
          new_issue_description(test)
        end
      end
    end
  end
end
