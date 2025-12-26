# frozen_string_literal: true

require 'erb'

module GitlabQuality
  module TestTooling
    module Report
      # Uses the API to create or update GitLab test cases with the results of tests from RSpec report files.
      class ResultsInTestCases < ReportAsIssue
        include Concerns::ResultsReporter

        attr_reader :issue_type, :gitlab

        def initialize(**kwargs)
          super
          @issue_type = 'test_case'
        end

        def find_or_create_testcase(test)
          find_testcase(test) || create_issue(test)
        end

        def add_result_issue_link_to_testcase(testcase, result_issue, test)
          results_section = testcase.description.include?(TEST_CASE_RESULTS_SECTION_TEMPLATE) ? '' : TEST_CASE_RESULTS_SECTION_TEMPLATE

          gitlab.edit_issue(iid: testcase.iid,
            options: { description: (testcase.description + results_section + "\n\n#{result_issue.web_url}") })
          # We are using test.testcase for the url here instead of testcase.web_url since it has the updated test case path
          puts "Added results issue #{result_issue.web_url} link to test case #{test.testcase}"
        end

        def update_testcase(testcase, test)
          puts "Labels updated for test case #{test.testcase}." if update_labels(testcase, test)
          puts "Quarantine section updated for test case #{test.testcase}." if update_quarantine_section(testcase, test)
        end

        private

        def find_testcase(test)
          testcase = find_testcase_by_iid(test) || find_issue(test)
          return unless testcase

          if testcase_needs_updating?(testcase, test)
            update_issue(testcase, test)
          else
            testcase
          end
        end

        def find_testcase_by_iid(test)
          iid = testcase_iid_from_url(test.testcase)

          return unless iid

          find_issue_by_iid(iid)
        end

        def testcase_iid_from_url(url)
          return warn(%(\nPlease update #{url} to test case url)) if url&.include?('/-/issues/')

          url && url.split('/').last.to_i
        end

        def new_issue_description(test)
          quarantine_section = test.quarantine? && test.quarantine_issue ? "\n\n### Quarantine issue\n\n#{test.quarantine_issue}" : ''

          "#{super}#{quarantine_section}\n\n#{execution_graph_section(test)}"
        end

        def execution_graph_section(test)
          formatted_title = ERB::Util.url_encode(test.name)

          <<~MKDOWN.strip
            ### Executions

            [Spec metrics on all environments](https://dashboards.quality.gitlab.net/d/cW0UMgv7k/single-spec-metrics?orgId=1&var-run_type=All&var-name=#{formatted_title})
          MKDOWN
        end

        def updated_description(testcase, test)
          historical_results_section = testcase.description.match(/### DO NOT EDIT BELOW THIS LINE[\s\S]+/)

          "#{new_issue_description(test)}\n\n#{historical_results_section}"
        end

        def testcase_needs_updating?(testcase, test)
          return false if %w[canary production preprod release].include?(pipeline)
          return true if issue_title_needs_updating?(testcase, test)

          !testcase.description.include?(execution_graph_section(test))
        end

        def quarantine_section_needs_updating?(testcase, test)
          if test.quarantine? && test.quarantine_issue
            return false if testcase.description.include?(test.quarantine_issue)
          else
            return false unless testcase.description.include?('Quarantine issue')
          end

          true
        end

        def update_quarantine_section(testcase, test)
          return unless quarantine_section_needs_updating?(testcase, test)

          new_description = updated_description(testcase, test)

          gitlab.edit_issue(iid: testcase.iid, options: { description: new_description })
        end
      end
    end
  end
end
