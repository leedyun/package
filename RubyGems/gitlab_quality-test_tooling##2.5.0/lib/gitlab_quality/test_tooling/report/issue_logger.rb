# frozen_string_literal: true

require 'fileutils'

module GitlabQuality
  module TestTooling
    module Report
      class IssueLogger
        def initialize(file_path:)
          @file_path = file_path
          @data = File.exist?(file_path) ? JSON.parse(File.read(file_path)) : Hash.new { |h, k| h[k] = [] }
        end

        def collect(test, issues)
          data[test.ci_job_url] += Array(issues).map(&:web_url)
          data[test.ci_job_url].uniq!
        end

        def write
          dirname = File.dirname(file_path)

          FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

          File.write(file_path, JSON.pretty_generate(data))
        end

        private

        attr_reader :file_path, :data
      end
    end
  end
end
