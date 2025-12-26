# frozen_string_literal: true

require_relative 'gitlab_client/job_client'

module GitlabQuality
  module TestTooling
    class JobTraceAnalyzer
      attr_reader :project, :token, :job_id

      FailureTraceDefinition = Struct.new(:type, :trace_start, :trace_end, :language, :label, keyword_init: true)
      FAILURE_TRACE_DEFINITIONS = [
        FailureTraceDefinition.new(
          type: :rspec,
          trace_start: "Failures:\n",
          trace_end: "[TEST PROF INFO]",
          language: :ruby,
          label: '~backend'
        ),
        FailureTraceDefinition.new(
          type: :jest,
          trace_start: "Summary of all failing tests\n",
          trace_end: "\nRan all test suites.",
          language: :javascript,
          label: '~frontend'
        ),
        FailureTraceDefinition.new(
          type: :workhorse,
          trace_start: "make: Entering directory '/builds/gitlab-org/gitlab/workhorse'",
          trace_end: "make: Leaving directory '/builds/gitlab-org/gitlab/workhorse'",
          language: :go,
          label: '~workhorse'
        ),
        FailureTraceDefinition.new(
          type: :rubocop,
          trace_start: "Running RuboCop in graceful mode:",
          trace_end: "section_end",
          language: :ruby,
          label: '~backend'
        )
      ].freeze

      TRANSIENT_ROOT_CAUSE_TO_TRACE_MAP =
        {
          failed_to_pull_image: ['job failed: failed to pull image'],
          gitlab_com_overloaded: ['gitlab is currently unable to handle this request due to load'],
          runner_disk_full: [
            'no space left on device',
            'Check free disk space'
          ],
          job_timeout: [
            'ERROR: Job failed: execution took longer than',
            'Rspec suite is exceeding the 80 minute limit and is forced to exit with error'
          ],
          gitaly: ['gitaly spawn failed'],
          infrastructure: [
            'the requested url returned error: 5', # any 5XX error code should be transient
            'error: downloading artifacts from coordinator',
            'error: uploading artifacts as "archive" to coordinator',
            '500 Internal Server Error',
            "Internal Server Error 500",
            '502 Bad Gateway',
            '503 Service Unavailable',
            'Error: EEXIST: file already exists',
            'Failed to connect to 127.0.0.1',
            "Failed to open TCP connection to",
            'connection reset by peer',
            'segmentation fault',
            'no space left on device',
            'Check free disk space',
            'CLUSTERDOWN',
            'Redis client could not fetch cluster information: Connection refused'
          ],
          flaky_test: [
            "We have detected a PG::QueryCanceled error in the specs, so we're failing early"
          ]
        }.freeze

      AFTER_SCRIPT_TRACE_START_MARKER = 'Running after_script'

      def initialize(project:, token:, job_id:)
        @project = project
        @token = token
        @job_id = job_id
      end

      def found_infrastructure_error?
        trace_to_search = failure_summary || main_trace

        TRANSIENT_ROOT_CAUSE_TO_TRACE_MAP[:infrastructure].any? do |search_string|
          found = trace_to_search.downcase.include?(search_string.downcase)

          puts "Found infrastructure error stacktrace: #{search_string}" if found

          found
        end
      end

      private

      def detected_failure_trace_definition
        return @detected_failure_trace_definition if defined?(@detected_failure_trace_definition)

        @detected_failure_trace_definition = FAILURE_TRACE_DEFINITIONS.find do |failure_trace_definition|
          job_trace.include?(failure_trace_definition.trace_start) &&
            job_trace.include?(failure_trace_definition.trace_end)
        end
      end

      def job_trace
        @job_trace ||= GitlabClient::JobClient.new(project: project, token: token, job_id: job_id).job_trace
      end

      def main_trace
        return job_trace unless job_trace.include?(AFTER_SCRIPT_TRACE_START_MARKER)

        job_trace.split(AFTER_SCRIPT_TRACE_START_MARKER).first
      end

      def failure_summary
        return unless detected_failure_trace_definition

        @failure_summary ||= main_trace
          .split(detected_failure_trace_definition.trace_start)
          .last
          .split(detected_failure_trace_definition.trace_end)
          .first
          .chomp
      end
    end
  end
end
