# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module TestResult
      class BaseTestResult
        IGNORED_FAILURES = [
          "Net::ReadTimeout",
          "403 Forbidden - Your account has been blocked",
          "API failed (502) with `GitLab is not responding",
          "unexpected token at 'GitLab is not responding'",
          "GitLab: Internal API error (502).",
          "could not be found (502)",
          "Error reference number: 502"
        ].freeze

        SHARED_EXAMPLES_CALLERS = %w[include_examples it_behaves_like].freeze

        attr_reader :report

        def initialize(report:, token: '', project: Runtime::Env.ci_project_path, ref: Runtime::Env.ci_commit_ref_name)
          @report = report
          @token = token
          @project = project
          @ref = ref
        end

        def stage
          @stage ||= file[%r{(?:api|browser_ui)/(?:(?:\d+_)?(\w+))}, 1] || category
        end

        def name
          raise NotImplementedError
        end

        def relative_file
          raise NotImplementedError
        end

        def section
          raise NotImplementedError
        end

        def category
          raise NotImplementedError
        end

        def skipped?
          raise NotImplementedError
        end

        def failures
          raise NotImplementedError
        end

        def product_group
          report['product_group'].to_s
        end

        def feature_category
          report['feature_category']
        end

        def failures?
          failures.any?
        end

        def product_group?
          product_group != ''
        end

        def failure_issue
          report['failure_issue']
        end

        def failure_issue=(new_failure_issue)
          report['failure_issue'] = new_failure_issue
        end

        def line_number
          report['line_number']
        end

        def level
          report['level']
        end

        def run_time
          report['run_time'].to_f.round(2)
        end

        def screenshot?
          !!screenshot
        end

        def quarantine?
          # The value for 'quarantine' could be nil, a hash, a string,
          # or true (if the test just has the :quarantine tag)
          # But any non-nil or false value should means the test is in quarantine
          !!quarantine
        end

        def conditional_quarantine?
          return true if quarantine? && quarantine.is_a?(Hash) && quarantine.has_key?('only')

          false
        end

        def file
          @file ||= relative_file.start_with?('qa/') ? "qa/#{relative_file}" : relative_file
        end

        def file_base_url
          @file_base_url ||= "https://gitlab.com/#{project}/-/blob/#{ref}/"
        end

        def test_file_link
          "[`#{file}#L#{line_number}`](#{file_base_url}#{file}#L#{line_number})"
        end

        def full_stacktrace
          failures.each do |failure|
            message = failure['message'] || ""
            message_lines = failure['message_lines'] || []

            next if IGNORED_FAILURES.any? { |e| message.include?(e) }

            return message_lines.empty? ? message : message_lines.join("\n")
          end
        end

        def calls_shared_examples?
          reported_line = files_client.file_contents_at_line(line_number)

          return false unless reported_line

          SHARED_EXAMPLES_CALLERS.any? { |caller_method| reported_line.strip.start_with?(caller_method) }
        end

        def files_client
          @files_client ||= GitlabClient::RepositoryFilesClient.new(
            token: token,
            project: project,
            file_path: file,
            ref: ref)
        end

        private

        attr_reader :token, :project, :ref

        def screenshot
          report.fetch('screenshot', nil)
        end

        def quarantine
          report.fetch('quarantine', nil)
        end
      end
    end
  end
end
