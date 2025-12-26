# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module GitlabClient
      class CommitsClient < GitlabClient
        def create(branch_name, file_path, new_content, message)
          commit = handle_gitlab_client_exceptions do
            client.create_commit(project, branch_name, message, [
              { action: :update, file_path: file_path, content: new_content }
            ])
          end

          Runtime::Logger.debug("Created commit #{commit['id']} (#{commit['web_url']}) on #{branch_name}") if commit
          commit
        end
      end
    end
  end
end
