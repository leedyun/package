# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module GitlabClient
      class IssuesDryClient < IssuesClient
        def create_issue(title:, description:, labels:, issue_type: 'issue', confidential: false)
          attrs = { description: description, labels: labels, confidential: confidential }

          puts "The following #{issue_type} would have been created:"
          puts "project: #{project}, title: #{title}, attrs: #{attrs}"
        end

        def edit_issue(iid:, options: {})
          puts "The #{project}##{iid} issue would have been updated with: #{options}"
        end

        def create_issue_note(iid:, note:)
          puts "The following note would have been posted on #{project}##{iid} issue: #{note}"
        end

        def edit_issue_note(issue_iid:, note_id:, note:)
          puts "The following note would have been edited on #{project}##{issue_iid} (note #{note_id}) issue: #{note}"
        end

        def create_issue_discussion(iid:, note:)
          puts "The following discussion would have been posted on #{project}##{iid} issue: #{note}"
        end

        def add_note_to_issue_discussion_as_thread(iid:, discussion_id:, note:)
          puts "The following discussion note would have been posted on #{project}##{iid} (discussion #{discussion_id}) issue: #{note}"
        end

        def upload_file(file_fullpath:)
          puts "The following file would have been uploaded: #{file_fullpath}"
        end
      end
    end
  end
end
