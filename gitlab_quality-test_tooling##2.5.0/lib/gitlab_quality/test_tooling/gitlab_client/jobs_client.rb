# frozen_string_literal: true

require 'gitlab'

module GitlabQuality
  module TestTooling
    module GitlabClient
      class JobsClient < GitlabClient
        def pipeline_jobs(pipeline_id:, scope:)
          client.pipeline_jobs(project, pipeline_id, scope: scope)
        end
      end
    end
  end
end
