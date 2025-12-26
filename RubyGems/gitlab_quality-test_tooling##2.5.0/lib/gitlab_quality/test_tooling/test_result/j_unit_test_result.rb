# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module TestResult
      class JUnitTestResult < BaseTestResult
        attr_accessor :testcase # Ignore it for now

        def name
          report['name']
        end

        def relative_file
          report['file']&.delete_prefix('./')
        end

        def skipped?
          report.search('skipped').any?
        end

        def failures # rubocop:disable Metrics/AbcSize
          failures = report.search('failure')
          return [] if failures.empty?

          failures.map do |exception|
            trace = exception.content.split("\n").map(&:strip)
            spec_file_first_index = trace.rindex do |line|
              report['file'] && line.include?(File.basename(report['file']))
            end

            exception['message'].gsub!(/(private_token=)[\w-]+/, '********')
            exception['message'].gsub!(/("Authorization": \[\n\s*"token )([\w-]+)/, '\1********')
            exception.content = exception.content.gsub(/(private_token=)[\w-]+/, '********')
            exception.content = exception.content.gsub(/("Authorization": \[\n\s*"token )([\w-]+)/, '\1********')
            {
              'message' => "#{exception['type']}: #{exception['message']}",
              'stacktrace' => trace.slice(0..spec_file_first_index).join("\n"),
              'message_lines' => trace.slice(0..spec_file_first_index)
            }
          end
        end

        def max_duration_for_test
          ''
        end

        def ci_job_url
          ENV.fetch('CI_JOB_URL', '')
        end
      end
    end
  end
end
