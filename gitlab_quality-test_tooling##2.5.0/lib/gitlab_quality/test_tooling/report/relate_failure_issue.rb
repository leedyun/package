# frozen_string_literal: true

require 'nokogiri'
require 'rubygems/text'

module GitlabQuality
  module TestTooling
    module Report
      # Uses the API to create or update GitLab issues with the results of tests from RSpec report files.
      # - Uses the API to create or update GitLab issues with the results of tests from RSpec report files.
      # - Takes the JSON test run reports, e.g. `$CI_PROJECT_DIR/gitlab-qa-run-*/**/rspec-*.json`
      # - Takes a project where failure issues should be created
      # - Find issue by title (with test description or test file), then further filter by stack trace, then pick the better-matching one
      # - Add the failed job to the issue description, and update labels
      class RelateFailureIssue < ReportAsIssue
        include TestTooling::Concerns::FindSetDri
        include Concerns::GroupAndCategoryLabels
        include Concerns::IssueReports

        DEFAULT_MAX_DIFF_RATIO_FOR_DETECTION = 0.15
        SYSTEMIC_EXCEPTIONS_THRESHOLD = 10
        SPAM_THRESHOLD_FOR_FAILURE_ISSUES = 3
        FAILURE_STACKTRACE_REGEX = %r{(?:(?:.*Failure/Error:(?<stacktrace>.+))|(?<stacktrace>.+))}m
        ISSUE_STACKTRACE_REGEX = /### Stack trace\s*(```)#{FAILURE_STACKTRACE_REGEX}(```)\n*\n###/m

        NEW_ISSUE_LABELS = Set.new(%w[test failure::new priority::2 automation:bot-authored]).freeze
        SCREENSHOT_IGNORED_ERRORS = ['500 Internal Server Error', 'fabricate_via_api!', 'Error Code 500'].freeze

        MultipleIssuesFound = Class.new(StandardError)

        def initialize(
          max_diff_ratio: DEFAULT_MAX_DIFF_RATIO_FOR_DETECTION,
          system_logs: [],
          base_issue_labels: nil,
          exclude_labels_for_search: nil,
          metrics_files: [],
          **kwargs)
          super
          @max_diff_ratio = max_diff_ratio.to_f
          @system_logs = Dir.glob(system_logs)
          @base_issue_labels = Set.new(base_issue_labels)
          @exclude_labels_for_search = Set.new(exclude_labels_for_search)
          @issue_type = 'issue'
          @commented_issue_list = Set.new
          @metrics_files = Array(metrics_files)
        end

        private

        attr_reader :max_diff_ratio, :system_logs, :base_issue_labels, :exclude_labels_for_search, :metrics_files

        def run!
          puts "Reporting test failures in `#{files.join(',')}` as issues in project `#{project}` via the API at `#{Runtime::Env.gitlab_api_base}`."

          TestResults::Builder.new(token: token, project: project, file_glob: files).test_results_per_file do |test_results|
            puts "=> Reporting #{test_results.count} tests in #{test_results.path}"
            process_test_results(test_results)
          end
        end

        def test_metric_collections
          @test_metric_collections ||= Dir.glob(metrics_files).map do |path|
            TestMetrics::JsonTestMetricCollection.new(path)
          end
        end

        def process_test_results(test_results)
          systemic_failures = systemic_failures_for_test_results(test_results)

          test_results.each do |test|
            collect_issues(test, relate_failure_to_issue(test)) if should_report?(test, systemic_failures)

            copy_failure_issue_to_test_metrics(test) if metrics_files.any?
          end

          test_results.write
        end

        def copy_failure_issue_to_test_metrics(test)
          failure_issue = test.failure_issue

          return unless failure_issue

          test_metric_collections.find do |test_metric_collection|
            test_metric = test_metric_collection.metric_for_test_id(test.example_id)

            if test_metric
              test_metric.fields['failure_issue'] = failure_issue
              test_metric_collection.write
            end
          end
        end

        def systemic_failures_for_test_results(test_results)
          test_results
            .flat_map { |test| test.failures.map { |failure| failure['message'].lines.first.chomp } }
            .compact
            .tally
            .select { |_e, count| count >= SYSTEMIC_EXCEPTIONS_THRESHOLD }
            .keys
        end

        def relate_failure_to_issue(test)
          puts " => Relating issues for test '#{test.name}'..."

          begin
            issue = find_issue_and_update_reports(test)

            issue = create_issue(test) unless issue || (test.quarantine? && !test.conditional_quarantine?)

            issue
          rescue MultipleIssuesFound => e
            warn(e.message)
          end
        end

        def find_issue_and_update_reports(test)
          issue, diff_ratio = find_failure_issue(test)
          return unless issue

          failure_already_reported = failure_already_reported?(issue, test)
          if failure_already_reported
            puts "  => Failure already reported on issue."
          else
            puts "  => Found issue #{issue.web_url} for test '#{test.name}' with a diff ratio of #{(diff_ratio * 100).round(2)}%."
            update_reports(issue, test)
            @commented_issue_list.add(issue.web_url)
          end

          issue
        end

        def failure_already_reported?(issue, test)
          @commented_issue_list.add(issue.web_url) if failed_issue_job_urls(issue).include?(test.ci_job_url)

          @commented_issue_list.include?(issue.web_url)
        end

        def create_issue(test)
          similar_issues = pipeline_issues_with_similar_stacktrace(test)

          if similar_issues.size >= SPAM_THRESHOLD_FOR_FAILURE_ISSUES
            puts "  => Similar failure issues have already been opened for the same pipeline environment, we won't create new issue"
            similar_issues.each do |similar_issue|
              puts "  => Please check issue: #{similar_issue.web_url}"
              update_reports(similar_issue, test)
            end
            return
          end

          created_issue = super
          test.failure_issue ||= created_issue.web_url

          created_issue
        end

        def pipeline_issues_with_similar_stacktrace(test)
          search_labels = (base_issue_labels + Set.new(%w[test failure::new])).to_a
          not_labels = exclude_labels_for_search.to_a
          find_issues_created_after(past_timestamp(2), state: 'opened', labels: search_labels, not_labels: not_labels).select do |issue|
            job_url_from_issue = failed_issue_job_url(issue)

            next if pipeline != pipeline_env_from_job_url(job_url_from_issue)

            stack_trace_comparator = StackTraceComparator.new(cleaned_stack_trace_from_test(test), cleaned_stack_trace_from_issue(issue))

            stack_trace_comparator.lower_than_diff_ratio?(max_diff_ratio)
          end
        end

        def pipeline_env_from_job_url(job_url)
          return if job_url.nil?

          if job_url.include?('/quality/')
            job_url.partition('/quality/').last.partition('/').first
          else
            Runtime::Env.default_branch
          end
        end

        def past_timestamp(hours_ago)
          timestamp = Time.now - (hours_ago * 60 * 60)
          timestamp.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
        end

        def failure_issues(test)
          find_issues_by_hash(
            test_hash(test),
            state: 'opened',
            labels: base_issue_labels + Set.new(%w[test]),
            not_labels: exclude_labels_for_search
          )
        end

        def cleaned_stack_trace_from_issue(issue)
          relevant_issue_stacktrace = find_issue_stacktrace(issue)
          return unless relevant_issue_stacktrace

          remove_unique_resource_names(relevant_issue_stacktrace)
        end

        def cleaned_stack_trace_from_test(test)
          test_failure_stacktrace = sanitize_stacktrace(test.full_stacktrace,
            FAILURE_STACKTRACE_REGEX) || test.full_stacktrace
          remove_unique_resource_names(test_failure_stacktrace)
        end

        def find_relevant_failure_issues(test) # rubocop:disable Metrics/AbcSize
          clean_first_test_failure_stacktrace = cleaned_stack_trace_from_test(test)
          # Search with the `search` param returns 500 errors, so we filter by `base_issue_labels` and then filter further in Ruby
          failure_issues(test).each_with_object({}) do |issue, memo|
            clean_relevant_issue_stacktrace = cleaned_stack_trace_from_issue(issue)
            next if clean_relevant_issue_stacktrace.nil?

            stack_trace_comparator = StackTraceComparator.new(clean_first_test_failure_stacktrace, clean_relevant_issue_stacktrace)

            if stack_trace_comparator.lower_or_equal_to_diff_ratio?(max_diff_ratio)
              puts "  => [DEBUG] Issue #{issue.web_url} has an acceptable diff ratio of #{stack_trace_comparator.diff_percent}%."
              # The `Gitlab::ObjectifiedHash` class overrides `#hash` which is used by `Hash#[]=` to compute the hash key.
              # This leads to a `TypeError Exception: no implicit conversion of Hash into Integer` error, so we convert the object to a hash before using it as a Hash key.
              # See:
              # - https://gitlab.com/gitlab-org/gitlab-qa/-/merge_requests/587#note_453336995
              # - https://github.com/NARKOZ/gitlab/commit/cbdbd1e32623f018a8fae39932a8e3bc4d929abb?_pjax=%23js-repo-pjax-container#r44484494
              memo[issue.to_h] = stack_trace_comparator.diff_ratio
            else
              puts "  => [DEBUG] Found issue #{issue.web_url} but stacktraces are too different (#{stack_trace_comparator.diff_percent}%).\n"
              puts "  => [DEBUG] Issue stacktrace:\n----------------\n#{clean_relevant_issue_stacktrace}\n----------------\n"
              puts "  => [DEBUG] Failure stacktrace:\n----------------\n#{clean_first_test_failure_stacktrace}\n----------------\n"
            end
          end
        end

        def find_issue_stacktrace(issue)
          issue_stacktrace = sanitize_stacktrace(issue.description, ISSUE_STACKTRACE_REGEX)
          return issue_stacktrace if issue_stacktrace

          puts "  => [DEBUG] Stacktrace couldn't be found for #{issue.web_url}!"
        end

        def sanitize_stacktrace(stacktrace, regex)
          stacktrace_match = stacktrace.match(regex)

          if stacktrace_match
            stacktrace_match[:stacktrace].gsub(/^\s*#.*$/, '').gsub(/^[[:space:]]+/, '').strip
          else
            puts "  => [DEBUG] Stacktrace doesn't match the regex (#{regex})!"
          end
        end

        def remove_unique_resource_names(stacktrace)
          stacktrace.gsub(/(QA User |qa-(test|user)-)[a-z0-9-]+/, '<unique-test-resource>').gsub(
            /(?:-|_)(?:\d+[a-z]|[a-z]+\d)[a-z\d]{4,}/, '<unique-hash>')
        end

        def find_failure_issue(test)
          relevant_issues = find_relevant_failure_issues(test)

          return nil if relevant_issues.empty?

          best_matching_issue, smaller_diff_ratio = relevant_issues.min_by { |_, diff_ratio| diff_ratio }

          raise(MultipleIssuesFound, %(Too many issues found for test '#{test.name}' (`#{test.relative_file}`)!)) unless relevant_issues.values.count(smaller_diff_ratio) == 1

          # Re-instantiate a `Gitlab::ObjectifiedHash` object after having converted it to a hash in #find_relevant_failure_issues above.
          best_matching_issue = Gitlab::ObjectifiedHash.new(best_matching_issue)

          test.failure_issue ||= best_matching_issue.web_url

          [best_matching_issue, smaller_diff_ratio]
        end

        def new_issue_description(test)
          super + [
            "\n### Stack trace",
            "```\n#{test.full_stacktrace}\n```",
            screenshot_section(test),
            system_log_errors_section(test),
            initial_reports_section(test)
          ].compact.join("\n\n")
        end

        def system_log_errors_section(test)
          correlation_id = test.failures.first['correlation_id']
          section = ''

          if system_logs.any? && !correlation_id.nil?
            section = SystemLogs::SystemLogsFormatter.new(
              system_logs,
              correlation_id
            ).system_logs_summary_markdown
          end

          if section.empty?
            puts "  => No system logs or correlation id provided, skipping this section in issue description"
            return
          end

          section
        end

        def up_to_date_labels(test:, issue: nil, new_labels: Set.new)
          (Set.new(base_issue_labels) + (super << pipeline_name_label)).to_a
        end

        def new_issue_assignee_id(test)
          return unless test.product_group?

          dri = test_dri(test.product_group, test.stage, test.section)
          puts "  => Assigning #{dri} as DRI for the issue."

          gitlab.find_user_id(username: dri)
        end

        def new_issue_due_date(test)
          return unless test.product_group?

          Date.today.next_month
        end

        def update_reports(issue, test)
          # We reopen closed issues to not lose any history
          state_event = issue.state == 'closed' ? 'reopen' : nil

          issue_attrs = {
            description: increment_reports(current_reports_content: issue.description, test: test).to_s,
            labels: up_to_date_labels(test: test, issue: issue)
          }
          issue_attrs[:state_event] = state_event if state_event

          gitlab.edit_issue(iid: issue.iid, options: issue_attrs)
          puts "  => Added a report in '#{issue.title}': #{issue.web_url}!"
        end

        def screenshot_section(test)
          return unless test.screenshot?

          failure = test.full_stacktrace
          return if SCREENSHOT_IGNORED_ERRORS.any? { |e| failure.include?(e) }

          relative_url = gitlab.upload_file(file_fullpath: test.screenshot_image)
          return unless relative_url

          "### Screenshot\n\n#{relative_url.markdown}"
        end

        # Checks if a test failure should be reported.
        #
        # @return [TrueClass|FalseClass] false if the test was skipped or failed because of a transient error that can be ignored.
        # Otherwise returns true.
        def should_report?(test, systemic_failure_messages)
          return false unless test.failures?

          puts "  => Systemic failures detected: #{systemic_failure_messages}" if systemic_failure_messages.any?
          failure_to_ignore = TestResult::BaseTestResult::IGNORED_FAILURES + systemic_failure_messages

          reason = ignored_failure_reason(test.failures, failure_to_ignore)

          if reason
            puts "  => Failure reporting skipped because #{reason}"

            false
          else
            true
          end
        end

        # Determine any reason to ignore a failure.
        #
        # @param [Array<Hash>] failures the failures associated with the failure.
        # @param [Array<String>] failure_to_ignore the failures messages that should be ignored.
        # @return [String] the reason to ignore the failures, or `nil` if any failures should not be ignored.
        def ignored_failure_reason(failures, failure_to_ignore)
          failures_to_ignore = compute_ignored_failures(failures, failure_to_ignore)
          return if failures_to_ignore.empty? || failures_to_ignore.size < failures.size

          "the errors included: #{failures_to_ignore.map { |e| "`#{e}`" }.join(', ')}"
        end

        # Determine the failures that should be ignored based on a list of exception messages to ignore.
        #
        # @param [Array<Hash>] failures the failures associated with the failure.
        # @param [Array<String>] failure_to_ignore the failures messages that should be ignored.
        # @return [Array<String>] the exception messages to ignore, or `nil` if any failures should not be ignored.
        def compute_ignored_failures(failures, failure_to_ignore)
          failures
            .filter_map { |e| failure_to_ignore.find { |m| e['message'].include?(m) } }
            .compact
        end
      end
    end
  end
end
