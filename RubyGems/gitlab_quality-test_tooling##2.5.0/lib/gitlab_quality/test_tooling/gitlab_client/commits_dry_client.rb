# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module GitlabClient
      class CommitsDryClient < CommitsClient
        def create(branch_name, file_path, new_content, message)
          puts "A commit would have been created on branch_name: #{branch_name}, file_path: #{file_path}, message: #{message} and content:"
          puts new_content
        end
      end
    end
  end
end
