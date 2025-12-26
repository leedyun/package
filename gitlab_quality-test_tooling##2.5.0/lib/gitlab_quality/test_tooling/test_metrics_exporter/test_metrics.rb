# frozen_string_literal: true

require 'time'

module GitlabQuality
  module TestTooling
    module TestMetricsExporter
      module TestMetrics
        # Single common timestamp for all exported example metrics to keep data points consistently grouped
        #
        # @return [Time]
        def time
          return @time if defined?(@time)

          created_at = Time.strptime(env('CI_PIPELINE_CREATED_AT'), '%Y-%m-%dT%H:%M:%S%z') if env('CI_PIPELINE_CREATED_AT')
          @time = Time.parse((created_at || Time.now).utc.strftime('%Y-%m-%d %H:%M:%S %z'))
        end

        # rubocop:disable Metrics/AbcSize
        # Metrics tags
        #
        # @param [RSpec::Core::Example] example
        # @param [Array<String>] custom_keys
        # @param [String]
        # @return [Hash]
        def tags(example, custom_keys, run_type)
          {
            name: example.full_description,
            file_path: example.metadata[:file_path].sub(/\A./, ''),
            status: status(example),
            quarantined: quarantined(example),
            job_name: job_name,
            merge_request: merge_request,
            run_type: run_type,
            feature_category: example.metadata[:feature_category],
            product_group: example.metadata[:product_group],
            exception_class: example.execution_result.exception&.class&.to_s,
            **custom_metrics(example.metadata, custom_keys)
          }.compact
        end
        # rubocop:enable Metrics/AbcSize

        # Metrics fields
        #
        # @param [RSpec::Core::Example] example
        # @param [Array<String>] custom_keys
        # @return [Hash]
        def fields(example, custom_keys)
          {
            id: example.id,
            run_time: (example.execution_result.run_time * 1000).round,
            job_url: Runtime::Env.ci_job_url,
            pipeline_url: env('CI_PIPELINE_URL'),
            pipeline_id: env('CI_PIPELINE_ID'),
            job_id: env('CI_JOB_ID'),
            merge_request_iid: merge_request_iid,
            failure_exception: example.execution_result.exception.to_s.delete("\n"),
            **custom_metrics(example.metadata, custom_keys)
          }.compact
        end

        # Return a more detailed status
        #
        # - if test is failed or pending, return rspec status
        # - if test passed but had more than 1 attempt, consider test flaky
        #
        # @param [RSpec::Core::Example] example
        # @return [Symbol]
        def status(example)
          rspec_status = example.execution_result.status
          return rspec_status if [:pending, :failed].include?(rspec_status)

          retry_attempts(example.metadata).positive? ? :flaky : :passed
        end

        # Retry attempts
        #
        # @param [Hash] example
        # @return [Integer]
        def retry_attempts(metadata)
          metadata[:retry_attempts] || 0
        end

        # Checks if spec is quarantined
        #
        # @param [RSpec::Core::Example] example
        # @return [String]
        def quarantined(example)
          return "false" unless example.metadata.key?(:quarantine)

          # if quarantine key is present and status is pending, consider it quarantined
          (example.execution_result.status == :pending).to_s
        end

        # Base ci job name
        #
        # @return [String]
        def job_name
          @job_name ||= Runtime::Env.ci_job_name&.gsub(%r{ \d{1,2}/\d{1,2}}, '')
        end

        # Check if it is a merge request execution
        #
        # @return [String]
        def merge_request
          (!!merge_request_iid).to_s
        end

        # Merge request iid
        #
        # @return [String]
        def merge_request_iid
          env('CI_MERGE_REQUEST_IID') || env('TOP_UPSTREAM_MERGE_REQUEST_IID')
        end

        # Custom test metrics
        #
        # @param [Hash] metadata
        # @param [Array] array of custom metrics keys
        # @return [Hash]
        def custom_metrics(metadata, custom_keys)
          return {} if custom_keys.nil?

          custom_metrics = {}
          custom_keys.each do |k|
            value = metadata[k.to_sym]
            v = value.is_a?(Numeric) || value.nil? ? value : value.to_s

            custom_metrics[k.to_sym] = v
          end

          custom_metrics
        end

        # Return non empty environment variable value
        #
        # @param [String] name
        # @return [String, nil]
        def env(name)
          return unless ENV[name] && !ENV[name].empty?

          ENV.fetch(name)
        end
      end
    end
  end
end
