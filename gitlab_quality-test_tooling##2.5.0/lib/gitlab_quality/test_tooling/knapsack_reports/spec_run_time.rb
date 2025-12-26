# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module KnapsackReports
      class SpecRunTime
        attr_reader :file, :expected, :actual, :expected_suite_duration, :actual_suite_duration, :project, :ref

        ACTUAL_TO_EXPECTED_SPEC_RUN_TIME_RATIO_THRESHOLD = 1.5 # actual run time is longer than expected by 50% +
        SPEC_WEIGHT_PERCENTAGE_TRESHOLD = 15 # a spec file takes 15%+ of the total test suite run time
        SUITE_DURATION_THRESHOLD = 70 * 60 # if test suite takes more than 70 minutes, job risks timing out
        FEATURE_CATEGORY_METADATA_REGEX = /(?<=feature_category: :)(?<feature_category>\w+)/

        def initialize(
          file:,
          expected:,
          actual:,
          expected_suite_duration:,
          actual_suite_duration:,
          token: '',
          project: Runtime::Env.ci_project_path,
          ref: Runtime::Env.ci_commit_ref_name)
          @file = file
          @expected = expected.to_f
          @actual = actual.to_f
          @expected_suite_duration = expected_suite_duration.to_f
          @actual_suite_duration = actual_suite_duration.to_f
          @token = token
          @project = project
          @ref = ref
        end

        def feature_category
          file_lines.each do |line|
            match = FEATURE_CATEGORY_METADATA_REGEX.match(line)
            next unless match

            break match[:feature_category]
          end
        end

        def should_report?
          # guideline proposed in https://gitlab.com/gitlab-org/quality/engineering-productivity/team/-/issues/354
          exceed_actual_to_expected_ratio_threshold? && test_suite_bottleneck?
        end

        def ci_pipeline_url_markdown
          "[#{ci_pipeline_id}](#{ci_pipeline_url})"
        end

        def ci_pipeline_created_at
          ENV.fetch('CI_PIPELINE_CREATED_AT', nil)
        end

        def ci_job_link_markdown
          "[#{ci_job_name}](#{ci_job_url})"
        end

        def file_link_markdown
          "[#{file}](#{file_link})"
        end

        def actual_percentage
          (actual / actual_suite_duration * 100).round(2)
        end

        def name
          nil
        end

        private

        attr_reader :token

        def exceed_actual_to_expected_ratio_threshold?
          actual / expected >= ACTUAL_TO_EXPECTED_SPEC_RUN_TIME_RATIO_THRESHOLD
        end

        def test_suite_bottleneck?
          # now we only report bottlenecks when they risk causing job timeouts
          return unless actual_suite_duration > SUITE_DURATION_THRESHOLD

          actual_percentage > SPEC_WEIGHT_PERCENTAGE_TRESHOLD
        end

        def ci_job_url
          ENV.fetch('CI_JOB_URL', nil)
        end

        def ci_job_name
          ENV.fetch('CI_JOB_NAME_SLUG', nil)
        end

        def ci_pipeline_id
          ENV.fetch('CI_PIPELINE_IID', nil)
        end

        def ci_pipeline_url
          ENV.fetch('CI_PIPELINE_URL', nil)
        end

        def file_link
          "https://gitlab.com/#{project}/-/blob/#{Runtime::Env.ci_commit_ref_name}/#{file}"
        end

        def file_lines
          files_client.file_contents.lines(chomp: true)
        end

        def files_client
          @files_client ||= GitlabClient::RepositoryFilesClient.new(
            token: token,
            project: project,
            file_path: file,
            ref: ref)
        end
      end
    end
  end
end
