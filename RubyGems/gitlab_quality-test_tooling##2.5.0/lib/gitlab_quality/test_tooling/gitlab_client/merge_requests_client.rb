# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module GitlabClient
      class MergeRequestsClient < GitlabClient
        def find_merge_request_changes(merge_request_iid:)
          handle_gitlab_client_exceptions do
            client.merge_request_changes(project, merge_request_iid)
          end
        end

        def create_merge_request(title:, source_branch:, target_branch:, description:, labels:, assignee_id: nil, reviewer_ids: [])
          attrs = {
            source_branch: source_branch,
            target_branch: target_branch,
            description: description,
            labels: labels,
            assignee_id: assignee_id,
            squash: true,
            remove_source_branch: true,
            reviewer_ids: reviewer_ids
          }.compact

          merge_request = handle_gitlab_client_exceptions do
            client.create_merge_request(project,
              title,
              attrs)
          end

          Runtime::Logger.debug("Created merge request #{merge_request['iid']} (#{merge_request['web_url']})") if merge_request

          merge_request
        end

        def find(iid: nil, options: {}, &select)
          select ||= :itself

          if iid
            find_merge_request(iid, &select)
          else
            find_merge_requests(options, &select)
          end
        end

        def merge_request_changed_files(merge_request_iid:)
          find_merge_request_changes(merge_request_iid: merge_request_iid)["changes"].map do |change|
            change["new_path"]
          end
        end

        def find_note(body:, merge_request_iid:)
          client.merge_request_notes(project, merge_request_iid, per_page: 100).auto_paginate.find do |mr_note|
            mr_note['body'] =~ /#{body}/
          end
        end

        def create_note(note:, merge_request_iid:)
          client.create_merge_request_note(project, merge_request_iid, note)
        end

        def update_note(id:, note:, merge_request_iid:)
          client.edit_merge_request_note(project, merge_request_iid, id, note)
        end

        private

        attr_reader :project, :token, :merge_request_iid

        def find_merge_request(iid, &select)
          handle_gitlab_client_exceptions do
            [client.merge_requests(project, iid)].select(&select)
          end
        end

        def find_merge_requests(options, &select)
          handle_gitlab_client_exceptions do
            client.merge_requests(project, options)
                  .auto_paginate
                  .select(&select)
          end
        end

        def client
          @client ||= Gitlab.client(
            endpoint: Runtime::Env.gitlab_api_base,
            private_token: token
          )
        end
      end
    end
  end
end
