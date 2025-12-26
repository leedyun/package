# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module GitlabQuality
  module TestTooling
    module Report
      module Concerns
        module IssueReports
          JOB_URL_REGEX = %r{(?<job_url>https://(?<host>[\w.]+)/(?<project_path>[\w\-./]+)/-/jobs/\d+)}
          FAILED_JOB_DESCRIPTION_REGEX = /First happened in #{JOB_URL_REGEX}\./m
          REPORT_ITEM_REGEX = /^1\. (?<report_date>\d{4}-\d{2}-\d{2}): #{JOB_URL_REGEX} \((?<pipeline_url>\S+)\) ?(?<extra_content>.*)$/
          LATEST_REPORTS_TO_SHOW = 10
          DISPLAYED_HISTORY_REPORTS_THRESHOLD = 510 # https://gitlab.com/gitlab-org/quality/engineering-productivity/team/-/issues/587
          DAILY_REPORTS_THRESHOLDS = 10

          class ReportsList
            def initialize(preserved_content:, section_header:, reports:, total_reports_count:, extra_content:)
              @preserved_content = preserved_content
              @section_header = section_header
              @reports = reports
              @total_reports_count = total_reports_count
              @extra_content = extra_content
            end

            def self.report_list_item(test, item_extra_content: nil)
              ReportListItem.new(job_url: test.ci_job_url, extra_content: item_extra_content)
            end

            def self.parse_report_date_from_string(date_string)
              parsed_time = Time.strptime(date_string, '%F')
              Time.utc(parsed_time.year, parsed_time.month, parsed_time.day)
            end

            def reports_count
              total_reports_count
            end

            def to_s
              [
                preserved_content,
                "#{section_header} (#{reports_count})",
                reports_list(total_reports_count),
                extra_content
              ].reject(&:blank?).compact.join("\n\n")
            end

            def spiked_in_short_period?
              latest_report = sorted_reports.first

              reports_for_latest_report_day = sorted_reports.count { |report| report.report_date == latest_report.report_date }

              reports_for_latest_report_day >= DAILY_REPORTS_THRESHOLDS
            end

            private

            attr_reader :preserved_content, :section_header, :reports, :total_reports_count, :extra_content

            def reports_list(total_reports_count)
              if sorted_reports.size > LATEST_REPORTS_TO_SHOW
                max_displayed_reports = DISPLAYED_HISTORY_REPORTS_THRESHOLD - LATEST_REPORTS_TO_SHOW
                [
                  "Last #{LATEST_REPORTS_TO_SHOW} reports:",
                  displayed_reports[...LATEST_REPORTS_TO_SHOW].join("\n"),
                  "<details><summary>With #{total_reports_count - LATEST_REPORTS_TO_SHOW} more reports (displaying up to #{max_displayed_reports} reports) </summary>",
                  displayed_reports[LATEST_REPORTS_TO_SHOW..].join("\n"),
                  "</details>"
                ].join("\n\n")
              else
                sorted_reports.join("\n")
              end
            end

            def sorted_reports
              @sorted_reports ||=
                reports.sort_by { |report| [report.report_date, report.job_id, report.to_s] }.reverse
            end

            def displayed_reports
              sorted_reports[0...DISPLAYED_HISTORY_REPORTS_THRESHOLD]
            end
          end

          class ReportListItem
            attr_reader :report_date

            def initialize(job_url:, report_date: now, pipeline_url: default_pipeline_url, extra_content: '')
              @job_url = job_url
              @report_date = report_date
              @pipeline_url = pipeline_url
              @extra_content = extra_content
            end

            def to_s
              "1. #{report_date}: #{job_url} (#{pipeline_url}) #{extra_content}".strip
            end

            def job_id
              job_url.split('/').last
            end

            private

            attr_reader :job_url, :pipeline_url, :extra_content

            def default_pipeline_url
              ENV.fetch('CI_PIPELINE_URL', 'pipeline url is missing')
            end

            def now
              Time.new.utc.strftime('%F')
            end
          end

          def initial_reports_section(test)
            <<~REPORTS
            ### Reports (1)

            #{ReportsList.report_list_item(test)}
            REPORTS
          end

          def increment_reports(
            current_reports_content:,
            test:,
            reports_section_header: '### Reports',
            item_extra_content: nil,
            reports_extra_content: nil)
            preserved_content = current_reports_content.split(reports_section_header).first&.strip
            reports = report_lines(current_reports_content) + [ReportsList.report_list_item(test, item_extra_content: item_extra_content)]

            total_reports_count = increment_total_reports_count(
              reports_section_header: reports_section_header,
              content: current_reports_content,
              reports: reports
            )

            ReportsList.new(
              preserved_content: preserved_content,
              section_header: reports_section_header,
              reports: reports,
              total_reports_count: total_reports_count,
              extra_content: reports_extra_content
            )
          end

          def increment_total_reports_count(reports_section_header:, content:, reports:)
            reports_count = reports.count

            return reports_count if reports_count < DISPLAYED_HISTORY_REPORTS_THRESHOLD

            count_match = content.match(/#{Regexp.escape(reports_section_header)} \((\d+)\)/)

            return reports_count unless count_match

            count_match[1].to_i + 1
          end

          def failed_issue_job_url(issue)
            job_urls_from_description(issue.description, REPORT_ITEM_REGEX).last ||
              # Legacy format
              job_urls_from_description(issue.description, FAILED_JOB_DESCRIPTION_REGEX).last
          end

          def failed_issue_job_urls(issue)
            job_urls_from_description(issue.description, REPORT_ITEM_REGEX) +
              # Legacy format
              job_urls_from_description(issue.description, FAILED_JOB_DESCRIPTION_REGEX)
          end

          private

          def report_lines(content)
            content.lines.filter_map do |line|
              match = line.match(REPORT_ITEM_REGEX)
              next unless match

              match_data_hash = match.named_captures.transform_keys(&:to_sym)
              ReportListItem.new(**match_data_hash.slice(:job_url, :report_date, :pipeline_url, :extra_content))
            end
          end

          def job_urls_from_description(issue_description, regex)
            issue_description.lines.filter_map do |line|
              match = line.match(regex)
              match[:job_url] if match
            end
          end
        end
      end
    end
  end
end
