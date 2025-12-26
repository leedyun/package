# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Report
      module Concerns
        module Utils
          MAX_TITLE_LENGTH = 255

          def title_from_test(test)
            title = new_issue_title(test)

            return title unless title.length > MAX_TITLE_LENGTH

            "#{title[...MAX_TITLE_LENGTH - 3]}..."
          end

          def new_issue_title(test)
            "[Test] #{partial_file_path(test.file)} | #{search_safe(test.name)}".strip
          end

          def partial_file_path(path)
            matched = path&.match(%r{(?<partial_path>(?:spec|ee|api|browser_ui)/.*)}i)
            return matched[:partial_path] if matched

            path
          end

          def search_safe(value)
            value.delete('"')
          end

          def pipeline
            # Gets the name of the pipeline the test was run in, to be used as the key of a scoped label
            #
            # Tests can be run in several pipelines:
            #   gitlab, nightly, staging, canary, production, preprod, MRs, and the default branch (master/main)
            #
            # Some of those run in their own project, so CI_PROJECT_NAME is the name we need. Those are:
            #   nightly, staging, canary, production, and preprod
            #
            # MR, master/main, and gitlab tests run in gitlab-qa, but we only want to report tests run on
            # master/main because the other pipelines will be monitored by the author of the MR that triggered them.
            # So we assume that we're reporting a master/main pipeline if the project name is 'gitlab'.

            @pipeline ||= Runtime::Env.pipeline_from_project_name
          end

          def readable_duration(duration_in_seconds)
            minutes = (duration_in_seconds / 60).to_i
            seconds = (duration_in_seconds % 60).round(2)

            min_output = normalize_duration_output(minutes, 'minute')
            sec_output = normalize_duration_output(seconds, 'second')

            "#{min_output} #{sec_output}".strip
          end

          private

          def normalize_duration_output(number, unit)
            if number <= 0
              ""
            elsif number <= 1
              "#{number} #{unit}"
            else
              "#{number} #{unit}s"
            end
          end
        end
      end
    end
  end
end
