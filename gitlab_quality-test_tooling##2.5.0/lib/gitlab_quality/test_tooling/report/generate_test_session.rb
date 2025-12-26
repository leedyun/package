# frozen_string_literal: true

require 'erb'
require 'date'

module GitlabQuality
  module TestTooling
    module Report
      class GenerateTestSession < ReportAsIssue
        def initialize(ci_project_token:, pipeline_stages: nil, **kwargs)
          super
          @ci_project_token = ci_project_token
          @pipeline_stages = Set.new(pipeline_stages)
          @issue_type = 'issue'
        end

        private

        attr_reader :ci_project_token, :pipeline_stages

        # rubocop:disable Metrics/AbcSize
        def run!
          puts "Generating test results in `#{files.join(',')}` as issues in project `#{project}` via the API at `#{Runtime::Env.gitlab_api_base}`."

          tests = Dir.glob(files).flat_map do |path|
            puts "Loading tests in #{path}"

            TestResults::JsonTestResults.new(path: path).to_a
          end

          tests = tests.select { |test| pipeline_stages.include? test.report["stage"] } unless pipeline_stages.empty?

          issue = gitlab.create_issue(
            title: "#{Time.now.strftime('%Y-%m-%d')} Test session report | #{Runtime::Env.qa_run_type}",
            description: generate_description(tests),
            labels: ['automation:bot-authored', 'Quality', 'QA', 'triage report', pipeline_name_label],
            confidential: confidential
          )

          # Workaround for https://gitlab.com/gitlab-org/gitlab/-/issues/295493
          unless Runtime::Env.qa_issue_url.to_s.empty?
            gitlab.create_issue_note(
              iid: issue.iid,
              note: "/relate #{Runtime::Env.qa_issue_url}")
          end

          issue&.web_url # Issue isn't created in dry-run mode
        end
        # rubocop:enable Metrics/AbcSize

        def generate_description(tests)
          <<~MARKDOWN.rstrip
          ## Session summary

          * Deploy version: #{Runtime::Env.deploy_version}
          * Deploy environment: #{Runtime::Env.deploy_environment}
          * Pipeline: #{Runtime::Env.pipeline_from_project_name} [#{Runtime::Env.ci_pipeline_id}](#{Runtime::Env.ci_pipeline_url})
          #{generate_summary(tests: tests)}

          #{generate_failed_jobs_listing}

          #{generate_stages_listing(tests)}

          #{generate_qa_issue_relation}

          #{generate_link_to_dashboard}
          MARKDOWN
        end

        def generate_summary(tests:, tests_by_status: nil)
          tests_by_status ||= tests.group_by(&:status)
          total = tests.size
          passed = tests_by_status['passed']&.size || 0
          failed = tests_by_status['failed']&.size || 0
          others = total - passed - failed

          <<~MARKDOWN.chomp
          * Total #{total} tests
          * Passed #{passed} tests
          * Failed #{failed} tests
          * #{others} other tests (usually skipped)
          MARKDOWN
        end

        def generate_failed_jobs_listing
          failed_jobs = fetch_pipeline_failed_jobs
          listings = failed_jobs.filter_map do |job|
            next if pipeline_stages.any? && !pipeline_stages.include?(job.stage)

            allowed_to_fail = ' (allowed to fail)' if job.allow_failure

            "* [#{job.name}](#{job.web_url})#{allowed_to_fail}"
          end.join("\n")

          <<~MARKDOWN.chomp if failed_jobs.any?
          ## Failed jobs

          #{listings}
          MARKDOWN
        end

        def generate_stages_listing(tests)
          generate_tests_by_stage(tests).map do |stage, tests_for_stage|
            tests_by_status = tests_for_stage.group_by(&:status)

            <<~MARKDOWN.chomp
            ### #{stage&.capitalize || 'Unknown'}

            #{generate_summary(
              tests: tests_for_stage, tests_by_status: tests_by_status)}

            #{generate_testcase_listing_by_status(
              tests: tests_for_stage, tests_by_status: tests_by_status)}
            MARKDOWN
          end.join("\n\n")
        end

        def generate_tests_by_stage(tests)
          # https://about.gitlab.com/handbook/product/product-categories/#devops-stages
          ordering = %w[
            manage
            plan
            create
            verify
            package
            release
            configure
            monitor
            secure
            defend
            growth
            fulfillment
            enablement
            self-managed
            saas
          ]

          tests.sort_by do |test|
            ordering.index(test.stage) || ordering.size
          end.group_by(&:stage)
        end

        def generate_testcase_listing_by_status(tests:, tests_by_status:)
          failed_tests = tests_by_status['failed']
          passed_tests = tests_by_status['passed']
          other_tests = tests.reject do |test|
            test.status == 'failed' || test.status == 'passed'
          end

          [
            (failed_listings(failed_tests) if failed_tests),
            (passed_listings(passed_tests) if passed_tests),
            (other_listings(other_tests) if other_tests.any?)
          ].compact.join("\n\n")
        end

        def failed_listings(failed_tests)
          generate_testcase_listing(failed_tests)
        end

        def passed_listings(passed_tests)
          <<~MARKDOWN.chomp
            <details><summary>Passed tests:</summary>

            #{generate_testcase_listing(passed_tests, passed: true)}

            </details>
          MARKDOWN
        end

        def other_listings(other_tests)
          <<~MARKDOWN.chomp
            <details><summary>Other tests:</summary>

            #{generate_testcase_listing(other_tests)}

            </details>
          MARKDOWN
        end

        def generate_testcase_listing(tests, passed: false)
          body = tests.group_by(&:testcase).map do |testcase, tests_with_same_testcase|
            tests_with_same_testcase.sort_by!(&:name)
            [
              generate_test_text(testcase, tests_with_same_testcase, passed),
              generate_test_job(tests_with_same_testcase),
              generate_test_status(tests_with_same_testcase),
              generate_test_actions(tests_with_same_testcase)
            ].join(' | ')
          end.join("\n")

          <<~MARKDOWN.chomp
          | Test | Job | Status | Action |
          | - | - | - | - |
          #{body}
          MARKDOWN
        end

        def generate_test_text(testcase, tests_with_same_testcase, passed)
          text = tests_with_same_testcase.map(&:name).uniq.join(', ')

          if testcase && !passed
            "[#{text}](#{testcase})"
          else
            text
          end
        end

        def generate_test_job(tests_with_same_testcase)
          tests_with_same_testcase.map do |test|
            ci_job_id = test.ci_job_url[/\d+\z/]

            "[#{ci_job_id}](#{test.ci_job_url})#{' ~"quarantine"' if test.quarantine?}"
          end.uniq.join(', ')
        end

        def generate_test_status(tests_with_same_testcase)
          tests_with_same_testcase.map(&:status).uniq.map do |status|
            %(~"#{status}")
          end.join(', ')
        end

        def generate_test_actions(tests_with_same_testcase)
          # All failed tests would be grouped together, meaning that
          # if one failed, all the tests here would be failed too.
          # So this check is safe. Same applies to 'passed'.
          # But all other status might be mixing together,
          # we cannot assume other statuses.
          if tests_with_same_testcase.first.status == 'failed'
            tests_having_failure_issue =
              tests_with_same_testcase.select(&:failure_issue)

            if tests_having_failure_issue.any?
              items = tests_having_failure_issue.uniq(&:failure_issue).map do |test|
                "<li>[ ] [failure issue](#{test.failure_issue})</li>"
              end.join(' ')

              "<ul>#{items}</ul>"
            else
              '<ul><li>[ ] failure issue exists or was created</li></ul>'
            end
          else
            '-'
          end
        end

        def generate_qa_issue_relation
          return unless Runtime::Env.qa_issue_url

          <<~MARKDOWN.chomp
          ## Release QA issue

          * #{Runtime::Env.qa_issue_url}

          /relate #{Runtime::Env.qa_issue_url}
          MARKDOWN
        end

        def generate_link_to_dashboard
          return unless Runtime::Env.qa_run_type

          <<~MARKDOWN.chomp
          ## Link to Grafana dashboard for run-type of #{Runtime::Env.qa_run_type}

          * https://dashboards.quality.gitlab.net/d/tR_SmBDVk/main-runs?orgId=1&refresh=1m&var-run_type=#{Runtime::Env.qa_run_type}
          MARKDOWN
        end

        def fetch_pipeline_failed_jobs
          failed_jobs = []

          ci_project_client = Gitlab.client(
            endpoint: Runtime::Env.ci_api_v4_url,
            private_token: ci_project_token)

          gitlab.handle_gitlab_client_exceptions do
            failed_jobs = ci_project_client.pipeline_jobs(
              Runtime::Env.ci_project_id,
              Runtime::Env.ci_pipeline_id,
              scope: 'failed')
          end

          failed_jobs
        end
      end
    end
  end
end
