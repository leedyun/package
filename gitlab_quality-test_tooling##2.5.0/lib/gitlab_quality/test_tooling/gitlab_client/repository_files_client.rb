# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module GitlabClient
      class RepositoryFilesClient < GitlabClient
        attr_reader :file_path, :ref

        def initialize(file_path:, ref:, **kwargs)
          @file_path = file_path
          @ref = ref
          super(**kwargs)
        end

        def file_contents
          handle_gitlab_client_exceptions do
            client.file_contents(project, file_path.gsub(%r{^/}, ""), ref)
          end
        end

        def file_contents_at_line(line_number)
          ignore_gitlab_client_exceptions do
            file_contents.lines(chomp: true)[line_number - 1]
          end
        end
      end
    end
  end
end
