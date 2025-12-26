# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module TestMetricsExporter
      class Formatter < RSpec::Core::Formatters::BaseFormatter
        RSpec::Core::Formatters.register(self, :stop)

        def stop(notification)
          setup_test_metrics_exporter(notification.examples)

          log_test_metrics.push_test_metrics(
            custom_keys_tags: config.custom_keys_tags,
            custom_keys_fields: config.custom_keys_fields
          )

          log_test_metrics.save_test_metrics(
            file_name: config.test_metric_file_name,
            custom_keys_tags: config.custom_keys_tags,
            custom_keys_fields: config.custom_keys_fields
          )
        end

        private

        attr_reader :log_test_metrics

        def config
          Config.configuration
        end

        # rubocop:disable Metrics/AbcSize
        def setup_test_metrics_exporter(examples)
          @log_test_metrics = LogTestMetrics.new(
            examples: examples,
            run_type: config.run_type
          )

          @log_test_metrics.configure_influxdb_client(
            influxdb_url: config.influxdb_url,
            influxdb_token: config.influxdb_token,
            influxdb_bucket: config.influxdb_bucket
          )

          @log_test_metrics.configure_gcs_client(
            gcs_bucket: config.gcs_bucket,
            gcs_project_id: config.gcs_project_id,
            gcs_credentials: config.gcs_credentials,
            gcs_metrics_file_name: config.gcs_metrics_file_name
          )
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
