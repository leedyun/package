# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module CLICommands
        GIT_LFS_VERSION = '2.8.0'

        def self.git_lfs_install_commands
          [
            "cd /tmp ; curl -qsL https://github.com/git-lfs/git-lfs/releases/download/v#{GIT_LFS_VERSION}/git-lfs-linux-amd64-v#{GIT_LFS_VERSION}.tar.gz | tar xzvf -",
            'cp /tmp/git-lfs /usr/local/bin'
          ].freeze
        end
      end
    end
  end
end
