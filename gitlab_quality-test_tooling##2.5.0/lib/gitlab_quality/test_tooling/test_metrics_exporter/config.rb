# frozen_string_literal: true

require "singleton"

module GitlabQuality
  module TestTooling
    module TestMetricsExporter
      class Config
        include Singleton

        class << self
          def configuration
            Config.instance
          end

          def configure
            yield(configuration)
          end
        end

        attr_accessor :influxdb_url,
          :influxdb_token,
          :influxdb_bucket,
          :gcs_bucket,
          :gcs_project_id,
          :gcs_credentials,
          :gcs_metrics_file_name,
          :test_metric_file_name,
          :run_type

        attr_writer :custom_keys_tags,
          :custom_keys_fields

        def custom_keys_tags
          @custom_keys_tags || []
        end

        def custom_keys_fields
          @custom_keys_fields || []
        end
      end
    end
  end
end
