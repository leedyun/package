# frozen_string_literal: true

require 'json'

module GitlabQuality
  module TestTooling
    module TestMeta
      class TestMetaUpdater
        include TestTooling::Concerns::FindSetDri

        attr_reader :project, :ref, :report_issue, :processed_commits

        TEST_PLATFORM_MAINTAINERS_SLACK_CHANNEL_ID = 'C0437FV9KBN' # test-platform-maintainers

        def initialize(token:, project:, specs_file:, processor:, ref: 'master', dry_run: false)
          @specs_file = specs_file
          @token = token
          @project = project
          @ref = ref
          @dry_run = dry_run
          @processor = processor
          @processed_commits = {}
        end

        def invoke!
          JSON.parse(File.read(specs_file)).tap do |contents|
            @report_issue = contents['report_issue']

            contents['specs'].each do |spec|
              processor.create_commit(spec, self)
              break if processed_commits.keys.count >= batch_limit
            end

            processor.create_merge_requests(self)

            processor.post_process(self)
          end
        end

        # Returns the number of records to process
        #
        # @return [Integer]
        def batch_limit
          ENV.fetch('BATCH_LIMIT', 10).to_i
        end

        # Add processed commits.
        #
        # processed_commits has the following form. Note that each key in the :commits hash
        # is the changed line number and the value is the spec changed.
        #
        # {
        #   "/file/path/for/spec_1" =>
        #     { :commits =>
        #       {
        #         "34" => {"stage"=> "create", "product_group" => "source_code".. },
        #         "38" => {"stage"=> "create", "product_group" => "source_code".. }
        #       },
        #       :branch => #<Gitlab::ObjectifiedHash>
        #     },
        #   "/file/path/for/spec_2" =>
        #     { :commits =>
        #       {
        #         "34" => {"stage"=> "create", "product_group" => "source_code".. },
        #         "38" => {"stage"=> "create", "product_group" => "source_code".. }
        #       },
        #       :branch => #<Gitlab::ObjectifiedHash>
        #     },
        # }
        #
        # @param [<String>] file_path the file path to the spec
        # @param [<Integer>] changed_line_no the changed line number for the commit
        # @param [<Gitlab::ObjectifiedHash>] branch the branch for the commit
        # @param [<Hash>] spec spec details hash
        # @return [Hash<String,Hash>] processed_commits
        def add_processed_commit(file_path, changed_line_no, branch, spec)
          if processed_commits[file_path].nil?
            processed_commits[file_path] = { commits: { changed_line_no.to_s => spec }, branch: branch }
          elsif processed_commits[file_path][:commits][changed_line_no.to_s].nil?
            processed_commits[file_path][:commits].merge!({ changed_line_no.to_s => spec })
          end
        end

        # Checks if changes have already been made to given file_path and line number
        #
        # @param [String] file_path path to the file
        # @param [Integer] changed_line_no updated line number
        # @return [Boolean]
        def commit_processed?(file_path, changed_line_no)
          processed_commits[file_path] && processed_commits[file_path][:commits][changed_line_no.to_s]
        end

        # Returns the branch for the given file_path
        #
        # @param [String] file_path path to the file
        # @return [<Gitlab::ObjectifiedHash>]
        def branch_for_file_path(file_path)
          processed_commits[file_path] && processed_commits[file_path][:branch]
        end

        # Fetch contents of file from the repository
        #
        # @param [String] file_path path to the file
        # @param [String] branch branch ref
        # @return [String] contents of the file
        def get_file_contents(file_path:, branch:)
          repository_files = GitlabClient::RepositoryFilesClient.new(token: token, project: project, file_path: file_path, ref: branch || ref)
          repository_files.file_contents
        end

        # Find all lines that contain any part of the example name
        #
        # @param [String] content the content of the spec file
        # @param [String] example_name the name of example to find
        # @return [Array<String, Integer>] first value holds the matched line, the second value holds the line number of matched line
        def find_example_match_lines(content, example_name)
          lines = content.split("\n")

          matched_lines = []
          example_name_for_parsing = example_name.dup

          lines.each_with_index do |line, line_index|
            string_within_quotes = spec_desc_string_within_quotes(line)

            regex = /^\s?#{Regexp.escape(string_within_quotes)}/ if string_within_quotes

            if !example_name_for_parsing.empty? && regex && example_name_for_parsing.match(regex)
              example_name_for_parsing.sub!(regex, '')
              matched_lines << [line, line_index]
            end
          rescue StandardError => e
            puts "Error: #{e}"
          end

          matched_lines
        end

        # Scans the content from the matched line until `do` is found to look for quarantine token
        #
        # @param [Array] matched_lines an array of arrays containing the matched line and their index
        # @param [String] file_contents the content of the spec file
        # @return [Bolean]
        def quarantined?(matched_lines, file_contents)
          lines = file_contents.split("\n")

          matched_lines.each do |matched_line|
            matched_line_starting_index = matched_line[1]

            lines[matched_line_starting_index..].each do |line|
              return true if line.include?('quarantine: {')
              break if / do$/.match?(line)
            end
          end

          false
        end

        # Update the provided matched_line with content from the block if given
        #
        # @param [Array<String, Integer>] matched_line first value holds the line content, the second value holds the line number
        # @param [String] content full orignal content of the spec file
        # @return [Array<String, Integer>] first value holds the new content, the second value holds the line number of the test
        def update_matched_line(matched_line, content)
          lines = content.split("\n")

          begin
            resulting_line = block_given? ? yield(matched_line[0]) : matched_line[0]
            lines[matched_line[1]] = resulting_line
          rescue StandardError => e
            puts "Error: #{e}"
          end

          [lines.join("\n") << "\n", matched_line[1]]
        end

        # Create a branch from the ref
        #
        # @param [String] name_prefix the prefix to attach to the branch name
        # @param [String] name the branch name
        # @return [Gitlab::ObjectifiedHash] the new branch
        def create_branch(name_prefix, name, ref)
          branch_name = [name_prefix, name.gsub(/\W/, '-')]
          @branches_client ||= (dry_run ? GitlabClient::BranchesDryClient : GitlabClient::BranchesClient).new(token: token, project: project)
          @branches_client.create(branch_name.join('-'), ref)
        end

        # Commit changes to a branch
        #
        # @param [Gitlab::ObjectifiedHash] branch the branch to commit to
        # @param [String] message the message to commit
        # @param [String] new_content the new content to commit
        # @return [Gitlab::ObjectifiedHash] the commit
        def commit_changes(branch, message, file_path, new_content)
          @commits_client ||= (dry_run ? GitlabClient::CommitsDryClient : GitlabClient::CommitsClient)
                                .new(token: token, project: project)
          @commits_client.create(branch['name'], file_path, new_content, message)
        end

        # Create a Merge Request with a given branch
        #
        # @param [String] title_prefix the prefix of the title
        # @param [String] example_name the example
        # @param [Gitlab::ObjectifiedHash] branch the branch
        # @param [Integer] assignee_id
        # @param [Array<Integer>] reviewer_ids
        # @param [String] labels comma seperated list of labels
        # @return [Gitlab::ObjectifiedHash] the created merge request
        def create_merge_request(title, branch, assignee_id = nil, reviewer_ids = [], labels = '')
          description = yield

          merge_request_client.create_merge_request(
            title: title,
            source_branch: branch['name'],
            target_branch: ref,
            description: description,
            labels: labels,
            assignee_id: assignee_id,
            reviewer_ids: reviewer_ids)
        end

        # Check if issue is closed
        #
        # @param [Gitlab::ObjectifiedHash] issue the issue
        # @return [Boolean] True or False
        def issue_is_closed?(issue)
          issue['state'] == 'closed'
        end

        # Get scoped label from issue
        #
        # @param [Gitlab::ObjectifiedHash] issue the issue
        # @param [String] scope
        # @return [String] scoped label
        def issue_scoped_label(issue, scope)
          issue['labels'].detect { |label| label.match(/#{scope}::/) }
        end

        # Fetch an issue
        #
        # @param [String] iid: The iid of the issue
        # @return [Gitlab::ObjectifiedHash]
        def fetch_issue(iid:)
          issue_client.find_issues(iid: iid).first
        end

        # Post note on isse
        #
        # @param [String] note the note to post
        # @return [Gitlab::ObjectifiedHash]
        def post_note_on_issue(note, issue_url)
          iid = issue_url&.split('/')&.last # split url segment, last segment of path is the issue id
          if iid
            issue_client.create_issue_note(iid: iid, note: note)
          else
            Runtime::Logger.info("#{self.class.name}##{__method__} Note was NOT posted on issue: #{issue_url}")
            nil
          end
        end

        # Post a note of merge reqest
        #
        # @param [String] note
        # @param [Integer] merge_request_iid
        # @return [Gitlab::ObjectifiedHash]
        def post_note_on_merge_request(note, merge_request_iid)
          merge_request_client.create_note(note: note, merge_request_iid: merge_request_iid)
        end

        # Fetch the id for the dri of the product group and stage
        # The first item returned is the id of the assignee and the second item is the handle
        #
        # @param [String] product_group
        # @param [String] devops_stage
        # @return [Array<Integer, String>]
        def fetch_dri_id(product_group, devops_stage, section)
          assignee_handle = ENV.fetch('QA_TEST_DRI_HANDLE', nil) || test_dri(product_group, devops_stage, section)

          [user_id_for_username(assignee_handle), assignee_handle]
        end

        # Fetch id for the given GitLab username/handle
        #
        # @param [String] username
        # @return [Integer]
        def user_id_for_username(username)
          issue_client.find_user_id(username: username)
        end

        # Post a message on Slack
        #
        # @param [String] message the message to post
        # @return [HTTP::Response]
        def post_message_on_slack(message)
          channel = ENV.fetch('SLACK_QA_CHANNEL', nil) || TEST_PLATFORM_MAINTAINERS_SLACK_CHANNEL_ID
          slack_options = {
            slack_webhook_url: ENV.fetch('CI_SLACK_WEBHOOK_URL', nil),
            channel: channel,
            username: "GitLab Quality Test Tooling",
            icon_emoji: ':warning:',
            message: message
          }
          puts "Posting Slack message to channel: #{channel}"

          (dry_run ? GitlabQuality::TestTooling::Slack::PostToSlackDry : GitlabQuality::TestTooling::Slack::PostToSlack).new(**slack_options).invoke!
        end

        # Provide indentation based on the given line
        #
        # @param[String] line the line to use for indentation
        # @return[String] indentation
        def indentation(line)
          # Indent the same number of spaces as the current line
          no_of_spaces = line[/\A */].size
          # If the first char on current line is not a quote, add two more spaces
          no_of_spaces += /['"]/.match?(line.lstrip[0]) ? 0 : 2

          " " * no_of_spaces
        end

        # Returns and existing merge request with the given title
        #
        # @param [String] title: Title of the merge request
        # @return [Array<Gitlab::ObjectifiedHash>] Merge requests
        def existing_merge_requests(title:)
          merge_request_client.find(options: { search: title, in: 'title', state: 'opened' })
        end

        # Infers product group label from the provided product group
        #
        # @param [String] product_group product group
        # @return [String]
        def label_from_product_group(product_group)
          label = labels_inference.infer_labels_from_product_group(product_group).to_a.first

          label ? %(/label ~"#{label}") : ''
        end

        # Returns the link to the Grafana dashboard for single spec metrics
        #
        # @param [String] example_name the full example name
        # @return [String]
        def single_spec_metrics_link(example_name)
          base_url = "https://dashboards.quality.gitlab.net/d/cW0UMgv7k/single-spec-metrics?orgId=1&var-run_type=All&var-name="
          base_url + CGI.escape(example_name)
        end

        private

        attr_reader :token, :specs_file, :dry_run, :processor

        # Returns any test description string within single or double quotes
        #
        # @param [String] line the line to check for any quoted string
        # @return [String] the match or nil if no match
        def spec_desc_string_within_quotes(line)
          match = line.match(/(?:it|describe|context|\s)+ ['"]([^'"]*)['"]/)
          match ? match[1] : nil
        end

        # Returns the GitlabIssueClient or GitlabIssueDryClient based on the value of dry_run
        #
        # @return [GitlabIssueDryClient | GitlabIssueClient]
        def issue_client
          @issue_client ||= (dry_run ? GitlabClient::IssuesDryClient : GitlabClient::IssuesClient).new(token: token, project: project)
        end

        # Returns the MergeRequestDryClient or MergeRequest based on the value of dry_run
        #
        # @return [MergeRequestDryClient | MergeRequest]
        def merge_request_client
          @merge_request_client ||= (dry_run ? GitlabClient::MergeRequestsDryClient : GitlabClient::MergeRequestsClient).new(
            token: token,
            project: project
          )
        end

        # Returns a cached instance of GitlabQuality::TestTooling::LabelsInference
        #
        #  @return [GitlabQuality::TestTooling::LabelsInference]
        def labels_inference
          @labels_inference ||= GitlabQuality::TestTooling::LabelsInference.new
        end
      end
    end
  end
end
