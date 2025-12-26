# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Report
      # Base class for specific health problems reporting.
      # Uses the API to create GitLab issues for any passed test coming from JSON test reports.
      # We expect the test reports to come from a new RSpec process where we retried failing specs.
      #
      # - Takes the JSON test reports like rspec-*.json
      # - Takes a project where flaky test issues should be created
      # - For every passed test in the report:
      #   - Find issue by test hash or create a new issue if no issue was found
      #   - Add a Failures/Flakiness/Slowness/... report in the "<Failures/Flakiness/Slowness/...> reports" note
      class HealthProblemReporter < ReportAsIssue
        include Concerns::GroupAndCategoryLabels
        include Concerns::IssueReports

        BASE_SEARCH_LABELS    = ['test'].freeze
        FOUND_IN_MR_LABEL     = '~"found:in MR"'
        FOUND_IN_MASTER_LABEL = '~"found:master"'

        def initialize(input_files: [], **kwargs)
          super(input_files: input_files, **kwargs)
        end

        def most_recent_report_date_for_issue(issue_iid:)
          reports_note = existing_reports_note(issue_iid: issue_iid)
          return unless reports_note

          most_recent_report_from_reports_note(reports_note)&.report_date
        end

        private

        def problem_type
          'unhealthy'
        end

        def test_is_applicable?(_test)
          false
        end

        def identity_labels
          []
        end

        def search_labels
          BASE_SEARCH_LABELS
        end

        def report_section_header
          ''
        end

        def reports_extra_content(_test)
          ''
        end

        def health_problem_status_label_quick_action(*)
          ''
        end

        def item_extra_content(_test)
          found_label
        end

        def most_recent_report_from_reports_note(reports_note)
          @most_recent_report_from_reports_note ||= report_lines(reports_note&.body.to_s).first
        end

        def run!
          puts "Reporting tests in `#{files.join(',')}` as issues in project `#{project}` via the API at `#{Runtime::Env.gitlab_api_base}`."

          TestResults::Builder.new(file_glob: files, token: token, project: project).test_results_per_file do |test_results|
            puts "=> Processing #{test_results.count} tests in #{test_results.path}"

            process_test_results(test_results)
          end
        end

        def process_test_results(test_results)
          reported_test_count = 0

          test_results.each do |test|
            next unless test_is_applicable?(test)

            puts " => Reporting #{problem_type} test '#{test.name}'..."

            issues = find_issues_by_hash(test_hash(test), state: 'opened', labels: search_labels)

            if issues.empty?
              issues << create_issue(test)
            else
              # Keep issues description up-to-date
              update_issues(issues, test)
            end

            update_reports(issues, test)
            collect_issues(test, issues)
            reported_test_count += 1
          end

          puts " => Reported #{reported_test_count} #{problem_type} tests."
        end

        def update_reports(issues, test)
          issues.each do |issue|
            puts "   => Reporting #{problem_type} test to existing issue: #{issue.web_url}"
            add_report_to_issue(issue: issue, test: test, related_issues: (issues - [issue]))
          end
        end

        def add_report_to_issue(issue:, test:, related_issues:)
          current_reports_note = existing_reports_note(issue_iid: issue.iid)

          new_reports_list = new_reports_list(current_reports_note: current_reports_note, test: test)
          note_body        = new_note_body(new_reports_list: new_reports_list, related_issues: related_issues)

          if current_reports_note
            gitlab.edit_issue_note(
              issue_iid: issue.iid,
              note_id: current_reports_note.id,
              note: note_body
            )
          else
            gitlab.create_issue_note(iid: issue.iid, note: note_body)
          end
        end

        def new_reports_list(current_reports_note:, test:)
          increment_reports(
            current_reports_content: current_reports_note&.body.to_s,
            test: test,
            reports_section_header: report_section_header,
            item_extra_content: item_extra_content(test),
            reports_extra_content: reports_extra_content(test)
          )
        end

        def new_note_body(new_reports_list:, related_issues:, options: {})
          report = new_reports_list

          quick_actions = [
            health_problem_status_label_quick_action(new_reports_list, options: options),
            identity_labels_quick_action,
            relate_issues_quick_actions(related_issues)
          ]

          quick_actions.unshift(report).join("\n")
        end

        def existing_reports_note(issue_iid:)
          gitlab.find_issue_notes(iid: issue_iid).find do |note|
            note.body.start_with?(report_section_header)
          end
        end

        def found_label
          if ENV.key?('CI_MERGE_REQUEST_IID')
            FOUND_IN_MR_LABEL
          else
            FOUND_IN_MASTER_LABEL
          end
        end

        def identity_labels_quick_action
          return if identity_labels.empty?

          %(/label #{identity_labels.map { |label| %(~"#{label}") }.join(' ')})
        end

        def relate_issues_quick_actions(issues)
          issues.map do |issue|
            "/relate #{issue.web_url}"
          end.join("\n")
        end
      end
    end
  end
end
