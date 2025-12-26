# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module TestResult
      class JsonTestResult < BaseTestResult
        PRIVATE_TOKEN_REGEX = /(private_token=)[\w-]+/
        AUTHENTICATION_TOKEN_REGEX = /("Authorization": \[\n\s*"token )([\w-]+)/

        OTHER_TESTS_MAX_DURATION = 45.40 # seconds

        TestLevelSpecification = Struct.new(:regex, :max_duration)

        TEST_LEVEL_SPECIFICATIONS = [
          TestLevelSpecification.new(%r{spec/features/}, 50.13),
          TestLevelSpecification.new(%r{spec/(controllers|requests)/}, 19.20),
          TestLevelSpecification.new(%r{spec/lib/}, 27.12),
          TestLevelSpecification.new(%r{qa/specs/features/}, 240)
        ].freeze

        def name
          # If we see a string representation of an object in a test full_description, we discard it.
          #
          # This is to ensure that tests would have a reproducible name, in case they don't have a name.
          #
          # Test example:
          #
          # it { is_expected.to eq(secondary_node) }
          #
          # Would have its full_description as follows:
          #
          # Gitlab::Geo.proxied_site on a primary for a proxied request with a proxy extra data header
          # for an existing site is expected to eq #<GeoNode id: 116, primary: false, oauth_application_id: 97
          # , enabled: true, access_key: [FILTERED], e...pdated_at: "2023-10-10 08:49:49.797128469 +0000",
          # sync_object_storage: true, secret_access_key: nil>
          #
          # Which would change for every test run due to the timestamps.
          #
          # See https://gitlab.com/gitlab-org/ruby/gems/gitlab_quality-test_tooling/-/merge_requests/77#note_1608793804
          report.fetch('full_description').split('#<').first
        end

        def relative_file
          report.fetch('file_path').delete_prefix('./')
        end

        def status
          report.fetch('status')
        end

        def skipped?
          status == 'pending'
        end

        def failed?
          status == 'failed'
        end

        def ci_job_url
          report.fetch('ci_job_url', '')
        end

        def testcase
          report.fetch('testcase', '')
        end

        def testcase=(new_testcase)
          report['testcase'] = new_testcase
        end

        def quarantine_type
          quarantine['type'] if quarantine?
        end

        def quarantine_issue
          quarantine['issue'] if quarantine?
        end

        def screenshot_image
          screenshot['image'] if screenshot?
        end

        def section
          report['section']
        end

        def category
          report['category']
        end

        def example_id
          report['id']
        end

        def ci_job_id
          report['ci_job_url'].split('/').last
        end

        def failures # rubocop:disable Metrics/AbcSize
          @failures ||=
            report.fetch('exceptions', []).filter_map do |exception|
              backtrace = exception['backtrace']
              next unless backtrace.respond_to?(:rindex)

              spec_file_first_index = backtrace.rindex do |line|
                line.include?(File.basename(report['file_path']))
              end

              message = redact_private_and_auth_tokens(exception['message'])
              message_lines = Array(exception['message_lines']).map { |line| redact_private_and_auth_tokens(line) }

              {
                'message' => "#{exception['class']}: #{message}",
                'message_lines' => message_lines,
                'stacktrace' => "#{format_message_lines(message_lines)}\n#{backtrace.slice(0..spec_file_first_index).join("\n")}",
                'correlation_id' => exception['correlation_id']
              }
            end
        end

        def allowed_to_be_slow?
          !!report['allowed_to_be_slow']
        end

        def slow_test?
          !allowed_to_be_slow? && run_time > max_duration_for_test
        end

        def max_duration_for_test
          test_level_specification = TEST_LEVEL_SPECIFICATIONS.find do |test_level_specification|
            example_id =~ test_level_specification.regex
          end
          return OTHER_TESTS_MAX_DURATION unless test_level_specification

          test_level_specification.max_duration
        end

        private

        def format_message_lines(message_lines)
          message_lines.is_a?(Array) ? message_lines.join("\n") : message_lines
        end

        def redact_private_and_auth_tokens(text)
          private_redacted = text.gsub(PRIVATE_TOKEN_REGEX, '********')
          private_redacted.gsub(AUTHENTICATION_TOKEN_REGEX, '\1********')
        end
      end
    end
  end
end
