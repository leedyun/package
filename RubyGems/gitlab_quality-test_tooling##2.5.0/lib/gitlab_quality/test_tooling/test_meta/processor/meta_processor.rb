# frozen_string_literal: true

require 'active_support/core_ext/string/filters'

module GitlabQuality
  module TestTooling
    module TestMeta
      module Processor
        class MetaProcessor
          class << self
            DESCRIPTION_REGEX = /('.*?')|(".*?")/

            def post_process
              raise NotImplementedError, 'Subclass must implement this method'
            end

            def create_merge_requests
              raise NotImplementedError, 'Subclass must implement this method'
            end

            private_class_method :new

            # Fetch existing MRs for given mr title
            #
            # @return [Array<Gitlab::ObjectifiedHash>]
            def existing_mrs
              @existing_mrs ||= context.existing_merge_requests(title: mr_title)
            end

            # Returns the index of the end of test description
            #
            # @param [String] line The line containing the test description
            # @return [Integer]
            def end_of_description_index(line)
              description_length = line.match(DESCRIPTION_REGEX)[0].length
              description_start_index = line.index(DESCRIPTION_REGEX)
              description_start_index + description_length
            end

            # List specs in markdown with details such as link to code, testcase, metrics and failure issue
            #
            # @param [Hash<String,Hash>] commits The commits hash to use for spec details
            # @return String
            def spec_details_from_commits(commits)
              commits.each_with_index.map do |(changed_line_number, spec), index|
                <<~MARKDOWN
                  #{index + 1}. [`#{spec['name']}`](https://gitlab.com/#{context.project}/-/blob/#{context.ref}/#{spec['file_path']}#L#{changed_line_number.to_i + 1})
                      | [Testcase](#{spec['testcase']}) | [Spec metrics](#{context.single_spec_metrics_link(spec['name'])})
                      #{failure_issue_text(spec)}
                MARKDOWN
              end.join("\n")
            end

            # Returns a string in markdown of failure issue and its link
            #
            # @param [Hash] spec the spec for failure issue
            # @return [String]
            def failure_issue_text(spec)
              spec['failure_issue'].empty? ? '' : "| [Failure issue](#{spec['failure_issue']})"
            end

            # Creates a commit depending on the context provided and adds it to a Hash of created commits
            #
            # @param [Hash] spec the spec to update
            # @param [TestMetaUpdater] context instance of TestMetaUpdater
            def create_commit(spec, context) # rubocop:disable Metrics/AbcSize
              @context = context
              @file_path = spec["file_path"]
              @file = spec["file"]
              @example_name = spec["name"]
              @failure_issue_url = spec["failure_issue"]

              issue_id = failure_issue_url&.split('/')&.last # split url segment, last segment of path is the issue id
              existing_branch = context.branch_for_file_path(file_path)

              @file_contents = context.get_file_contents(file_path: file_path,
                branch: existing_branch && existing_branch['name'])

              @failure_issue = context.fetch_issue(iid: issue_id) if issue_id

              spec['failure_issue_assignee_handle'] = @failure_issue['assignee']['username'] if @failure_issue && @failure_issue['assignee']

              new_content, @changed_line_no = add_metadata

              return unless proceed_with_commit?

              branch = existing_branch ||
                context.create_branch("#{self::BRANCH_PREFIX}-#{SecureRandom.hex(4)}", @file, context.ref)

              context.commit_changes(branch, commit_message, file_path, new_content)

              context.add_processed_commit(file_path, changed_line_no, branch, spec)
            end

            private

            attr_reader :failure_issue_url, :failure_issue
          end
        end
      end
    end
  end
end
