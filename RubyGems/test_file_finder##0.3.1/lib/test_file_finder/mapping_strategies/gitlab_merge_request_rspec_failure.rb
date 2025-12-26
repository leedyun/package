# frozen_string_literal: true

require 'faraday'
require 'json'
require 'set'

module TestFileFinder
  module MappingStrategies
    ##
    # GitlabMergeRequestRSpecFailure strategy finds test files that failed
    # in a GitLab merge request, using the Unit Test Reports feature
    # https://docs.gitlab.com/ee/ci/unit_test_reports.html
    #
    # It uses the project path and merge request iid to fetch
    # the test report of the merge request, which contains the test suites
    # that ran in the CI pipeline.
    #
    # It returns file names of rspec failures in the pipeline.
    class GitlabMergeRequestRspecFailure
      TEST_REPORTS_URL_TEMPLATE = 'https://gitlab.com/%{project_path}/-/merge_requests/%{merge_request_iid}/test_reports.json'

      attr_reader :project_path, :merge_request_iid

      def initialize(project_path:, merge_request_iid:)
        @project_path = project_path
        @merge_request_iid = merge_request_iid
      end

      def match(_files = nil)
        test_suites.each_with_object(Set.new) do |suite, result|
          unresolved_failures(suite).each do |failure|
            rspec_file(failure) do |spec|
              result << spec
            end
          end
        end.to_a
      end

      private

      def test_suites
        return to_enum(__method__) unless block_given?

        @test_suites ||= merge_request_test_reports['suites']
        @test_suites.each { |suite| yield suite }
      end

      def unresolved_failures(suite)
        return to_enum(__method__, suite) unless block_given?

        suite['new_failures'].each { |failure| yield failure }
        suite['existing_failures'].each { |failure| yield failure }
      end

      def rspec_file(failure)
        file = failure['file'].sub('./', '')

        yield(file) if file.end_with?('spec.rb')
      end

      def merge_request_test_reports
        test_reports_url = format(TEST_REPORTS_URL_TEMPLATE,
          { project_path: project_path, merge_request_iid: merge_request_iid })

        response = Faraday.get(test_reports_url, {}, { 'Accept' => 'application/json' })

        case response.status
        when 204
          raise TestFileFinder::TestReportError,
            "Test report for merge request #{merge_request_iid} is not ready, please try again later."
        when 400
          raise TestFileFinder::TestReportError, "The project #{project_path} does not have test reports configured."
        when 500
          raise TestFileFinder::TestReportError, 'Unable to retrieve test report, please try again later.'
        end

        JSON.parse(response.body)
      end
    end
  end
end
