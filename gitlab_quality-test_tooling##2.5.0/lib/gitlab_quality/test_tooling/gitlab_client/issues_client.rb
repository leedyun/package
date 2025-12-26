# frozen_string_literal: true

require 'gitlab'

module Gitlab
  # Monkey patch the Gitlab client to use the correct API path and add required methods
  class Client
    def team_member(project, id)
      get("/projects/#{url_encode(project)}/members/all/#{id}")
    end

    def issue_discussions(project, issue_id, options = {})
      get("/projects/#{url_encode(project)}/issues/#{issue_id}/discussions", query: options)
    end

    def create_issue_discussion(project, issue_iid, options = {})
      post("/projects/#{url_encode(project)}/issues/#{issue_iid}/discussions", query: options)
    end

    def add_note_to_issue_discussion_as_thread(project, issue_id, discussion_id, options = {})
      post("/projects/#{url_encode(project)}/issues/#{issue_id}/discussions/#{discussion_id}/notes", query: options)
    end
  end
end

module GitlabQuality
  module TestTooling
    module GitlabClient
      # The GitLab client is used for API access: https://github.com/NARKOZ/gitlab
      class IssuesClient < GitlabClient
        REPORTER_ACCESS_LEVEL = 20

        def assert_user_permission!
          handle_gitlab_client_exceptions do
            member = client.team_member(project, user.id)

            abort_not_permitted(member.access_level) if member.access_level < REPORTER_ACCESS_LEVEL
          end
        rescue Gitlab::Error::NotFound
          abort_member_not_found(user)
        end

        def find_issues(iid: nil, options: {}, &select)
          select ||= :itself

          handle_gitlab_client_exceptions do
            break [client.issue(project, iid)].select(&select) if iid

            client.issues(project, options)
                  .auto_paginate
                  .select(&select)
          end
        end

        def find_issue_notes(iid:)
          handle_gitlab_client_exceptions do
            client.issue_notes(project, iid, order_by: 'created_at', sort: 'asc').auto_paginate
          end
        end

        def find_issue_discussions(iid:)
          handle_gitlab_client_exceptions do
            client.issue_discussions(project, iid, order_by: 'created_at', sort: 'asc').auto_paginate
          end
        end

        def create_issue(title:, description:, labels:, issue_type: 'issue', assignee_id: nil, due_date: nil, confidential: false)
          attrs = {
            issue_type: issue_type,
            description: description,
            labels: labels,
            assignee_id: assignee_id,
            due_date: due_date,
            confidential: confidential
          }.compact

          handle_gitlab_client_exceptions do
            client.create_issue(project, title, attrs)
          end
        end

        def edit_issue(iid:, options: {})
          handle_gitlab_client_exceptions do
            client.edit_issue(project, iid, options)
          end
        end

        def create_issue_note(iid:, note:)
          handle_gitlab_client_exceptions do
            client.create_issue_note(project, iid, note)
          end
        end

        def edit_issue_note(issue_iid:, note_id:, note:)
          handle_gitlab_client_exceptions do
            client.edit_issue_note(project, issue_iid, note_id, note)
          end
        end

        def create_issue_discussion(iid:, note:)
          handle_gitlab_client_exceptions do
            client.create_issue_discussion(project, iid, body: note)
          end
        end

        def add_note_to_issue_discussion_as_thread(iid:, discussion_id:, note:)
          handle_gitlab_client_exceptions do
            client.add_note_to_issue_discussion_as_thread(project, iid, discussion_id, body: note)
          end
        end

        def find_user_id(username:)
          handle_gitlab_client_exceptions do
            user = client.users(username: username)&.first
            user['id'] unless user.nil?
          end
        end

        def upload_file(file_fullpath:)
          ignore_gitlab_client_exceptions do
            client.upload_file(project, file_fullpath)
          end
        end

        private

        attr_reader :token, :project

        def user
          return @user if defined?(@user)

          @user ||= begin
            client.user
          rescue Gitlab::Error::NotFound
            abort_user_not_found
          end
        end

        def abort_not_permitted(access_level)
          abort "#{user.username} must have at least Reporter access to the project '#{project}' to use this feature. Current access level: #{access_level}"
        end

        def abort_user_not_found
          abort "User not found for given token."
        end

        def abort_member_not_found(user)
          abort "#{user.username} must be a member of the '#{project}' project."
        end
      end
    end
  end
end
