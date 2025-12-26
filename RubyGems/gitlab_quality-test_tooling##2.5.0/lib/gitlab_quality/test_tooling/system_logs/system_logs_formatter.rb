# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module SystemLogs
      class SystemLogsFormatter
        NUM_OF_LOG_SECTIONS = 4

        def initialize(base_paths, correlation_id)
          @base_paths = base_paths
          @correlation_id = correlation_id
        end

        def system_logs_summary_markdown
          log_sections = Array.new(NUM_OF_LOG_SECTIONS) { [] }

          @base_paths.each do |base_path|
            all_logs = [
              Finders::Rails::ApiLogFinder.new(base_path).find(@correlation_id),
              Finders::Rails::ExceptionLogFinder.new(base_path).find(@correlation_id),
              Finders::Rails::ApplicationLogFinder.new(base_path).find(@correlation_id),
              Finders::Rails::GraphqlLogFinder.new(base_path).find(@correlation_id)
            ]

            create_log_summary_sections!(all_logs, log_sections)
          end

          log_sections.prepend('### System Logs') unless log_sections.all?(&:empty?)
          log_sections.join("\n").rstrip
        end

        private

        def create_log_summary_sections!(all_logs, sections)
          sections.zip(all_logs) do |section, logs|
            unless logs.empty?
              section_title = "\n#### #{logs.first.name}"
              section.append(section_title) unless section.include?(section_title)
              section.append(create_log_summaries(logs))
            end
          end
        end

        def create_log_summaries(logs)
          section = []

          logs.each do |log|
            log_summary = <<~MARKDOWN.chomp
              <details><summary>Click to expand</summary>

              ```json
              #{JSON.pretty_generate(log.summary)}
              ```
              </details>
            MARKDOWN

            section.append(log_summary)
          end

          section.join("\n\n")
        end
      end
    end
  end
end
