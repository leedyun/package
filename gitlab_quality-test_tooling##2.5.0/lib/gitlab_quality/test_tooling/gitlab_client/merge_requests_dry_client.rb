# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module GitlabClient
      class MergeRequestsDryClient < MergeRequestsClient
        def find_merge_request_changes(merge_request_iid:)
          puts "Finding changes for merge_request_id #{merge_request_iid}"
          puts "project: #{project}"
        end

        def merge_request_changed_files(merge_request_iid:)
          puts "Changed files for #{merge_request_iid}"
          []
        end

        def find_note(body:, merge_request_iid:)
          puts "Find note for #{merge_request_iid} with body: #{body} for mr_iid: #{merge_request_iid}"
        end

        def create_note(note:, merge_request_iid:)
          puts "The following note would have been created with body: #{note} for mr_iid: #{merge_request_iid}"
        end

        def update_note(id:, note:, merge_request_iid:)
          puts "The following note would have been updated id: #{id} with body: #{note} for mr_iid: #{merge_request_iid}"
        end

        def create_merge_request(title:, source_branch:, target_branch:, description:, labels:, assignee_id:, reviewer_ids:)
          puts "A merge request would be created with title: #{title} " \
               "source_branch: #{source_branch} target_branch: #{target_branch} " \
               "description: #{description} labels: #{labels}, assignee_id: #{assignee_id}" \
               "reviewer_ids: #{reviewer_ids}"
        end
      end
    end
  end
end
