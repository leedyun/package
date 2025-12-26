# frozen_string_literal: true

require 'table_print'

module GitlabQuality
  module TestTooling
    module FailedJobsTable
      class << self
        # Create table with formatted list of failed jobs
        #
        # @param [Array<Gitlab::ObjectifiedHash>] jobs
        # @return [String]
        def create(jobs:)
          "```\n#{TablePrint::Printer.table_print(collect_results(jobs))}\n```\n"
        end

        private

        # Format list of failed jobs
        #
        # @param [Array<Gitlab::ObjectifiedHash>] jobs
        # @return [Array]
        def collect_results(jobs)
          jobs.sort_by(&:stage)
            .reject { |job| job.name.downcase.include?("quarantine") }
            .map do |job|
              {
                "Job" => job.name,
                "Stage" => job.stage,
                "Failure Reason" => job.failure_reason
              }
            end
        end
      end
    end
  end
end
