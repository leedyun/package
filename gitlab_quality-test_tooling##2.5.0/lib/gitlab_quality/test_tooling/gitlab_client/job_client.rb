# frozen_string_literal: true

require 'gitlab'

module GitlabQuality
  module TestTooling
    module GitlabClient
      class JobClient < GitlabClient
        attr_reader :job_id

        def initialize(token:, project:, job_id:)
          super

          @job_id = job_id
        end

        def job_trace
          trace = ''

          ignore_gitlab_client_exceptions do
            trace = client.job_trace(project, job_id)
          end

          trace
        end
      end
    end
  end
end
