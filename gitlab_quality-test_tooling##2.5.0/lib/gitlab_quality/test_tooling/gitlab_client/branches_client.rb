# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module GitlabClient
      class BranchesClient < GitlabClient
        def create(branch_name, ref)
          branch = handle_gitlab_client_exceptions do
            client.create_branch(project, branch_name, ref)
          end

          Runtime::Logger.debug("Created branch #{branch['name']} (#{branch['web_url']})") if branch
          branch
        end
      end
    end
  end
end
