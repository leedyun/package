# frozen_string_literal: true

require 'fog/google'

module GitlabQuality
  module TestTooling
    module TestMetricsExporter
      module Support
        module GcsTools
          # GCS Client
          #
          # @param project_id [String]
          # @param credentials [String]
          # @return [Fog::Storage::Google]
          def gcs_client(project_id:, credentials:)
            Fog::Storage::Google.new(
              google_project: project_id || raise("Missing Google project_id"),
              **gcs_creds(credentials)
            )
          end

          # GCS Credentials
          #
          # @param credentials [String]
          # @return [Hash]
          def gcs_creds(credentials)
            json_key = credentials || raise('Missing Google credentials')
            return { google_json_key_location: json_key } if File.exist?(json_key)

            { google_json_key_string: json_key }
          end
        end
      end
    end
  end
end
