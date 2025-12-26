# frozen_string_literal: true

module Gitlab
  module QA
    module Support
      module ConfigScripts
        # Add a git server hooks with a custom error message
        # See https://docs.gitlab.com/ee/administration/server_hooks.html for details
        def self.add_git_server_hooks(docker, name)
          global_server_prereceive_hook = <<~SCRIPT
            #!/usr/bin/env bash

            if [[ \\$GL_PROJECT_PATH =~ 'reject-prereceive' ]]; then
              echo 'GL-HOOK-ERR: Custom error message rejecting prereceive hook for projects with GL_PROJECT_PATH matching pattern reject-prereceive'
              exit 1
            fi
          SCRIPT

          [
            docker.exec(name, 'mkdir -p /opt/gitlab/embedded/service/gitlab-shell/hooks/pre-receive.d'),
            docker.write_files(name) do |f|
              f.write(
                '/opt/gitlab/embedded/service/gitlab-shell/hooks/pre-receive.d/pre-receive.d',
                global_server_prereceive_hook, false
              )
            end,
            docker.exec(name, 'chmod +x /opt/gitlab/embedded/service/gitlab-shell/hooks/pre-receive.d/*')
          ]
        end
      end
    end
  end
end
