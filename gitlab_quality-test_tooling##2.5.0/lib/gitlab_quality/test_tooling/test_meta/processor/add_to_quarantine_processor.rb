# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module TestMeta
      module Processor
        class AddToQuarantineProcessor < MetaProcessor
          QUARANTINE_METADATA = <<~META
            ,
            %{indentation}quarantine: {
            %{indentation}  issue: '%{issue_url}',
            %{indentation}  type: %{quarantine_type}
            %{indentation}}%{suffix}
          META
          BRANCH_PREFIX = 'quarantine'

          class << self
            # Creates the merge requests to quarantine E2E tests
            #
            # @param [TestMetaUpdater] context instance of TestMetaUpdater
            def create_merge_requests(context)
              @context = context

              context.processed_commits.each_value do |record|
                branch, devops_stage, product_group, file = extract_data_from_record(record)

                mr_title = format("%{prefix} %{file}", prefix: '[E2E] QUARANTINE:', file: file).truncate(72, omission: '')

                gitlab_bot_user_id = context.user_id_for_username(Runtime::Env.gitlab_bot_username)

                merge_request = context.create_merge_request(mr_title, branch, gitlab_bot_user_id) do
                  merge_request_description(record, devops_stage, product_group)
                end

                if merge_request
                  Runtime::Logger.info("  Created MR for quarantine: #{merge_request.web_url}")
                  record[:merge_request] = merge_request
                end
              end
            end

            # Performs post processing. Posts a list of MRs in a note on report_issue and Slack.
            # Also posts note on failure issues for un-quarantining of the quarantined
            #
            # @param [TestMetaUpdater] context instance of TestMetaUpdater
            def post_process(context)
              @context = context

              web_urls = context.processed_commits.values.map { |value| "- #{value[:merge_request].web_url}\n" }.join

              return if web_urls.empty?

              context.post_note_on_issue(mrs_created_note_for_report_issue(web_urls), context.report_issue)

              context.post_message_on_slack(mrs_created_message_for_slack(web_urls))

              post_unquarantine_note_on_failure_issue
            end

            private

            attr_reader :context, :file_path, :file_contents, :failure_issue_url, :example_name,
              :mr_title, :failure_issue, :changed_line_no, :matched_lines

            # Checks if the failure issue is closed or if there is already an MR open
            #
            # @return [Boolean]
            def proceed_with_commit? # rubocop:disable Metrics/AbcSize
              if context.issue_is_closed?(failure_issue)
                Runtime::Logger.info("  Failure issue '#{failure_issue_url}' is closed. Will not proceed with creating MR.")
                return false
              elsif context.commit_processed?(file_path, changed_line_no)
                Runtime::Logger.info("  Record already processed for #{file_path}:#{changed_line_no}. Will not proceed with creating MR.")
                return false
              elsif failure_is_related_to_test_environment?
                Runtime::Logger.info("  Failure issue '#{failure_issue_url}' is environment related. Will not proceed with creating MR.")
                return false
              elsif context.quarantined?(matched_lines, file_contents)
                Runtime::Logger.info("  This test is already in quarantine: #{file_path}:#{changed_line_no}. Will not proceed with creating MR.")
                return false
              end

              true
            end

            def failure_is_related_to_test_environment?
              context.issue_scoped_label(failure_issue, 'failure')&.split('::')&.last == 'test-environment'
            end

            def extract_data_from_record(record)
              first_spec = record[:commits].values.first
              [record[:branch], first_spec["stage"], first_spec["product_group"], first_spec["file"]]
            end

            # Posts note on failure issue to un-quarantine the test
            #
            def post_unquarantine_note_on_failure_issue
              context.processed_commits.each_value do |record|
                merge_request = record[:merge_request]
                next unless merge_request

                record[:commits].each_value do |spec|
                  devops_stage = spec["stage"]
                  product_group = spec["product_group"]
                  failure_issue = spec["failure_issue"]

                  next unless failure_issue

                  note = context.post_note_on_issue(unquarantine_note_for_failure(spec, product_group, devops_stage, merge_request),
                    failure_issue)

                  Runtime::Logger.info("  Posted note on failure issue for un-quarantine: #{failure_issue}") if note
                end
              end
            end

            def merge_request_description(record, devops_stage, product_group)
              <<~MARKDOWN
                ## What does this MR do?

                Quarantines the following e2e tests:

                #{spec_details_from_commits(record[:commits])}

                This MR was created based on data from reliable e2e test report: #{context.report_issue}

                ### Check-list

                - [ ] General code guidelines check-list
                  - [ ] [Code review guidelines](https://docs.gitlab.com/ee/development/code_review.html)
                  - [ ] [Style guides](https://docs.gitlab.com/ee/development/contributing/style_guides.html)
                - [ ] Quarantine test check-list
                  - [ ] Follow the [Quarantining Tests guide](https://about.gitlab.com/handbook/engineering/infrastructure/test-platform/debugging-qa-test-failures/#quarantining-tests).
                  - [ ] Confirm the test has a [`quarantine:` tag with the specified quarantine type](https://about.gitlab.com/handbook/engineering/infrastructure/test-platform/debugging-qa-test-failures/#quarantined-test-types).
                  - [ ] Note if the test should be [quarantined for a specific environment](https://docs.gitlab.com/ee/development/testing_guide/end_to_end/execution_context_selection.html#quarantine-a-test-for-a-specific-environment).
                  - [ ] (Optionally) In case of an emergency (e.g. blocked deployments), consider adding labels to pick into auto-deploy (~"Pick into auto-deploy" ~"priority::1" ~"severity::1").
                - [ ] To ensure a faster turnaround, ask in the `#quality_maintainers` Slack channel for someone to review and merge the merge request, rather than assigning it directly.

                <!-- Base labels. -->
                /label ~"Quality" ~"QA" ~"type::maintenance" ~"maintenance::pipelines"

                <!--
                Choose the stage that appears in the test path, e.g. ~"devops::create" for
                `qa/specs/features/browser_ui/3_create/web_ide/add_file_template_spec.rb`.
                -->
                /label ~"devops::#{devops_stage}"
                #{context.label_from_product_group(product_group)}

                <div align="center">
                (This MR was automatically generated by [`gitlab_quality-test_tooling`](https://gitlab.com/gitlab-org/ruby/gems/gitlab_quality-test_tooling) at #{Time.now.utc})
                </div>
              MARKDOWN
            end

            def commit_message
              <<~COMMIT_MESSAGE
                Quarantine end-to-end test

                #{"Quarantine #{example_name}".truncate(72)}
              COMMIT_MESSAGE
            end

            def mrs_created_note_for_report_issue(web_urls)
              <<~ISSUE_NOTE

                The following merge requests have been created to quarantine the unstable tests:

                #{web_urls}
              ISSUE_NOTE
            end

            def unquarantine_note_for_failure(spec, product_group, devops_stage, merge_request)
              failure_issue_assignee_handle = get_failure_issue_assignee_handle(spec, product_group, devops_stage)
              <<~ISSUE_NOTE
                @#{failure_issue_assignee_handle} This test will be quarantined in #{merge_request.web_url} based on data from reliable e2e test report: #{context.report_issue}

                Please take this issue forward to un-quarantine the test by either addressing the issue yourself or delegating it to the relevant product group.

                If this issue is delegated, please make sure to update the assignee. Thanks.
              ISSUE_NOTE
            end

            def mrs_created_message_for_slack(web_urls)
              <<~MSG
                *Action Required!* The following merge requests have been created to quarantine the unstable tests identified
                in the reliable test report: #{context.report_issue}

                #{web_urls}

                Maintainers are requested to review and merge the above MRs. Thank you.
              MSG
            end

            def get_failure_issue_assignee_handle(spec, product_group, devops_stage)
              return spec["failure_issue_assignee_handle"] if spec["failure_issue_assignee_handle"]

              _, assignee_handle = context.fetch_dri_id(product_group, devops_stage, nil)
              assignee_handle
            end

            # Add quarantine metadata to the file content and replace it
            #
            # @return [Array<String, Integer>] first value holds the new content, the second value holds the line number of the test
            def add_metadata # rubocop:disable Metrics/AbcSize
              @matched_lines = context.find_example_match_lines(file_contents, example_name)

              context.update_matched_line(matched_lines.last, file_contents.dup) do |line|
                indentation = context.indentation(line)

                if line.sub(DESCRIPTION_REGEX, '').include?(',') && line.split.last != 'do'
                  line[line.rindex(',')] = format(QUARANTINE_METADATA.rstrip, issue_url: failure_issue_url, indentation: indentation, suffix: ',', quarantine_type: quarantine_type)
                else
                  line[line.rindex(' ')] = format(QUARANTINE_METADATA.rstrip, issue_url: failure_issue_url, indentation: indentation, suffix: ' ', quarantine_type: quarantine_type)
                end

                line
              end
            end

            # Returns the quarantine type based on the failure scoped label
            #
            # @return [String]
            def quarantine_type
              case context.issue_scoped_label(failure_issue, 'failure')&.split('::')&.last
              when 'new', 'investigating'
                ':investigating'
              when 'broken-test'
                ':broken'
              when 'bug'
                ':bug'
              when 'flaky-test'
                ':flaky'
              when 'stale-test'
                ':stale'
              when 'test-environment'
                ':test_environment'
              else
                ':investigating'
              end
            end
          end
        end
      end
    end
  end
end
