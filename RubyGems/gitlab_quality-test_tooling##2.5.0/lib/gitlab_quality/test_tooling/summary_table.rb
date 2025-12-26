# frozen_string_literal: true

require 'nokogiri'
require 'table_print'

module GitlabQuality
  module TestTooling
    class SummaryTable
      def self.create(input_files:, **options)
        "```\n#{TablePrint::Printer.table_print(collect_results(input_files, **options))}```\n"
      end

      # rubocop:disable Metrics/AbcSize
      def self.collect_results(input_files, **options)
        sort_by = options[:sort_by]
        sort_direction = options[:sort_direction]
        hide_passed_tests = options[:hide_passed_tests]

        stage_wise_results = Dir.glob(input_files).each_with_object([]) do |report_file, stage_wise_results|
          stage_hash = {}
          stage_hash["Dev Stage"] = File.basename(report_file, ".*").capitalize

          report_stats = Nokogiri::XML(File.open(report_file)).children[0].attributes

          next if hide_passed_tests && report_stats["failures"].value.to_i.zero? && report_stats["errors"].value.to_i.zero?

          stage_hash["Total"] = report_stats["tests"].value
          stage_hash["Failures"] = report_stats["failures"].value
          stage_hash["Errors"] = report_stats["errors"].value
          stage_hash["Skipped"] = report_stats["skipped"].value
          stage_hash["Result"] = result_emoji(report_stats)

          stage_wise_results << stage_hash
        end

        stage_wise_results.sort_by! { |stage_hash| stage_hash[sort_by] } if sort_by
        stage_wise_results.reverse! if sort_direction == :desc

        stage_wise_results
      end
      # rubocop:enable Metrics/AbcSize

      def self.result_emoji(report_stats)
        report_stats["failures"].value.to_i.positive? || report_stats["errors"].value.to_i.positive? ? "❌" : "✅"
      end
    end
  end
end
