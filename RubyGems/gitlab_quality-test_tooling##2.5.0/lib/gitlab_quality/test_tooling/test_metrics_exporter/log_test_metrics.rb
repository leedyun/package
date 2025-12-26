# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module TestMetricsExporter
      class LogTestMetrics
        include TestMetrics
        include Support::InfluxdbTools
        include Support::GcsTools

        CUSTOM_METRICS_KEY = :custom_test_metrics

        def initialize(
          examples:,
          run_type: nil
        )
          @examples = examples
          @run_type = run_type
        end

        def configure_influxdb_client(influxdb_url: nil, influxdb_token: nil, influxdb_bucket: nil)
          @influxdb_url = influxdb_url
          @influxdb_token = influxdb_token
          @influxdb_bucket = influxdb_bucket
        end

        def configure_gcs_client(gcs_bucket: nil, gcs_project_id: nil, gcs_credentials: nil, gcs_metrics_file_name: nil)
          @gcs_bucket = gcs_bucket
          @gcs_project_id = gcs_project_id
          @gcs_credentials = gcs_credentials
          @gcs_metrics_file_name = gcs_metrics_file_name
        end

        # Push test execution metrics
        #
        # @param [Array<String>] custom_keys_tags
        # @param [Array<String>] custom_keys_fields
        # @return [nil]
        def push_test_metrics(custom_keys_tags: nil, custom_keys_fields: nil)
          @test_metrics ||= examples.filter_map { |example| parse_test_results(example, custom_keys_tags, custom_keys_fields) }

          push_test_metrics_to_influxdb
          push_test_metrics_to_gcs
        end

        # Save metrics in json file
        #
        # @param [String] file_name
        # @param [Array<String>] custom_keys_tags
        # @param [Array<String>] custom_keys_fields
        # @return [nil]
        def save_test_metrics(file_name:, custom_keys_tags: nil, custom_keys_fields: nil)
          return Runtime::Logger.warn("No file_name provided, not saving test metrics") if file_name.nil?

          @test_metrics ||= examples.filter_map { |example| parse_test_results(example, custom_keys_tags, custom_keys_fields) }
          file = "tmp/#{file_name}"

          File.write(file, test_metrics.to_json) && Runtime::Logger.info("Saved test metrics to #{file}")
        rescue StandardError => e
          Runtime::Logger.error("Failed to save test execution metrics, error: #{e}")
        end

        private

        attr_reader :examples, :test_metrics, :influxdb_url, :influxdb_token, :influxdb_bucket, :run_type, :gcs_bucket,
          :gcs_project_id, :gcs_credentials, :gcs_metrics_file_name

        # Push test execution metrics to Influxdb
        #
        # @return [nil]
        def push_test_metrics_to_influxdb
          write_api(url: influxdb_url, token: influxdb_token, bucket: influxdb_bucket).write(data: test_metrics)
          Runtime::Logger.info("Pushed #{test_metrics.length} test execution entries to Influxdb")
        rescue StandardError => e
          Runtime::Logger.error("Failed to push test execution metrics to Influxdb, error: #{e}")
        end

        # Push test execution metrics to GCS
        #
        # @return [nil]
        def push_test_metrics_to_gcs
          gcs_client(project_id: gcs_project_id, credentials: gcs_credentials)
            .put_object(
              gcs_bucket || raise("Missing GCS bucket name"),
              gcs_metrics_file_name,
              test_metrics.to_json,
              force: true,
              content_type: 'application/json'
            )

          Runtime::Logger.info("Pushed #{test_metrics.length} test execution entries to GCS")
        rescue StandardError => e
          Runtime::Logger.error("Failed to push test execution metrics to GCS, error: #{e}")
        end

        # Transform example to influxdb compatible metrics data
        # https://github.com/influxdata/influxdb-client-ruby#data-format
        #
        # @param [RSpec::Core::Example] example
        # @param [Array<String>] custom_keys_tags
        # @param [Array<String>] custom_keys_fields
        # @return [Hash]
        def parse_test_results(example, custom_keys_tags, custom_keys_fields)
          {
            name: 'test-stats',
            time: time,
            tags: tags(example, custom_keys_tags, run_type),
            fields: fields(example, custom_keys_fields)
          }
        rescue StandardError => e
          Runtime::Logger.error("Failed to transform example '#{example.id}', error: #{e}")
          nil
        end
      end
    end
  end
end
