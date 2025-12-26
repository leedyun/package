# frozen_string_literal: true

require 'set'

module GitlabQuality
  module TestTooling
    module Report
      class ReportAsIssue
        include Concerns::Utils

        def initialize(token:, input_files:, related_issues_file: nil, project: nil, confidential: false, dry_run: false, **_kwargs)
          @token = token
          @project = project
          @gitlab = (dry_run ? GitlabClient::IssuesDryClient : GitlabClient::IssuesClient).new(token: token, project: project)
          @files = Array(input_files)
          @confidential = confidential
          @issue_logger = IssueLogger.new(file_path: related_issues_file) unless related_issues_file.nil?
        end

        def invoke!
          validate_input!

          issue_url = run!

          write_issues_log_file

          issue_url
        end

        private

        attr_reader :token, :gitlab, :files, :project, :issue_type, :confidential, :issue_logger

        def run!
          raise NotImplementedError
        end

        def collect_issues(test, issues)
          issue_logger&.collect(test, issues)
        end

        def write_issues_log_file
          issue_logger&.write
        end

        def test_hash(test)
          # Should not be more than 50 characters if we want it indexed.
          #
          # See https://gitlab.com/gitlab-org/ruby/gems/gitlab_quality-test_tooling/-/issues/27#note_1607276486
          OpenSSL::Digest.hexdigest('SHA256', "#{test.relative_file}#{test.name}")[..40]
        end

        def new_issue_description(test)
          <<~DESCRIPTION
          ### Test metadata

          <!-- Don't modify this section as it's auto-generated -->
          | Field | Value |
          | ------ | ------ |
          | File URL | #{test.test_file_link} |
          | Filename | `#{test.relative_file}` |
          | Description | `` #{test.name} `` |
          | Test level | `#{test.level}` |
          | Hash | `#{test_hash(test)}` |
          | Max expected duration | < #{test.max_duration_for_test} seconds |
          #{"| Test case | #{test.testcase} |" if test.testcase}
          <!-- Don't modify this section as it's auto-generated -->
          DESCRIPTION
        end

        def new_issue_labels(_test)
          []
        end

        def new_issue_assignee_id(_test)
          nil
        end

        def new_issue_due_date(_test)
          nil
        end

        def validate_input!
          assert_project!
          assert_input_files!(files)
          gitlab.assert_user_permission!
        end

        def assert_project!
          return if project

          abort "Please provide a valid project ID or path with the `-p/--project` option!"
        end

        def assert_input_files!(files)
          return if Dir.glob(files).any?

          abort "Please provide valid JUnit report files. No files were found matching `#{files.join(',')}`"
        end

        def create_issue(test)
          attrs = {
            title: title_from_test(test),
            description: new_issue_description(test),
            labels: new_issue_labels(test).to_a,
            issue_type: issue_type,
            assignee_id: new_issue_assignee_id(test),
            due_date: new_issue_due_date(test),
            confidential: confidential
          }.compact

          gitlab.create_issue(**attrs).tap do |issue|
            puts "Created new #{issue_type}: #{issue&.web_url}"
          end
        end

        def update_issues(issues, test)
          issues.each do |issue|
            update_issue(issue, test)
          end
        end

        def update_issue(issue, test)
          issue_attrs = {}

          new_description = new_issue_description(test)
          issue_attrs[:description] = new_description if issue.description != new_description

          new_labels = up_to_date_labels(test: test, issue: issue).to_a
          issue_attrs[:add_labels] = new_labels if (new_labels - issue.labels).any?

          gitlab.edit_issue(iid: issue.iid, options: issue_attrs) if issue_attrs.any?
        end

        def issue_labels(issue)
          issue&.labels&.to_set || Set.new
        end

        def update_labels(issue, test, new_labels = Set.new)
          labels = up_to_date_labels(test: test, issue: issue, new_labels: new_labels)

          return if issue_labels(issue) == labels

          gitlab.edit_issue(iid: issue.iid, options: { labels: labels.to_a })
        end

        def up_to_date_labels(test:, issue: nil, new_labels: Set.new)
          labels = issue_labels(issue)
          labels |= new_labels.to_set
          ee_test?(test) ? labels << 'Enterprise Edition' : labels.delete('Enterprise Edition')

          if test.respond_to?(:quarantine?) && test.quarantine?
            labels << 'quarantine'
            labels << "quarantine::#{test.quarantine_type}"
          else
            labels.delete_if { |label| label.include?('quarantine') }
          end

          labels << 'rspec-shared-examples' if test.respond_to?(:calls_shared_examples?) && test.calls_shared_examples?

          labels
        end

        def find_issues_by_hash(test_hash, labels: Set.new, not_labels: Set.new, state: nil)
          search_options = { search: test_hash, labels: labels.to_a, not: { labels: not_labels.to_a } }
          search_options[:state] = state if state
          search_options[:in] = 'description'
          gitlab.find_issues(options: search_options)
        end

        def find_issues_for_test(test, labels:, not_labels: Set.new, state: nil)
          search_options = { labels: labels.to_a, not: { labels: not_labels.to_a } }
          search_options[:state] = state if state
          search_options[:search] = test.file.to_s.empty? ? test.name : partial_file_path(test.file)
          search_options[:in] = 'title'

          gitlab.find_issues(options: search_options).find_all { |issue| issue_match_test?(issue, test) }
        end

        def find_issues_created_after(timestamp, labels:, not_labels: Set.new, state: nil)
          search_options = { labels: labels.to_a, not: { labels: not_labels.to_a }, created_after: timestamp }
          search_options[:state] = state if state

          gitlab.find_issues(options: search_options)
        end

        def issue_match_test?(issue, test)
          issue_title = issue.title.strip
          test_file_path_found = !test.file.to_s.empty? && issue_title.include?(partial_file_path(test.file))

          if test.name
            issue_title.include?(test.name) || test_file_path_found
          else
            test_file_path_found
          end
        end

        def pipeline_name_label
          case pipeline
          when 'production'
            'found:gitlab.com'
          when 'canary', 'staging'
            "found:#{pipeline}.gitlab.com"
          when 'staging-canary'
            "found:canary.staging.gitlab.com"
          when 'preprod'
            'found:pre.gitlab.com'
          when 'nightly', Runtime::Env.default_branch, 'staging-ref', 'release'
            "found:#{pipeline}"
          when 'customers-gitlab-com'
            'found:customers.stg.gitlab.com'
          else
            puts "  => [DEBUG] No `found:*` label for the `#{pipeline}` pipeline!"
          end
        end

        def ee_test?(test)
          test.file =~ %r{features/ee/(api|browser_ui)}
        end
      end
    end
  end
end
