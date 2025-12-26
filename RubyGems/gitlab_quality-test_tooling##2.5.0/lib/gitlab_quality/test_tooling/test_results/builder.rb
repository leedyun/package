# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module TestResults
      class Builder
        def initialize(file_glob:, token: nil, project: nil, ref: 'master')
          @file_glob = file_glob
          @token = token
          @project = project
          @ref = ref
        end

        def test_results_per_file
          Dir.glob(file_glob).each do |path|
            extension = File.extname(path)

            test_results =
              case extension
              when '.json'
                TestResults::JsonTestResults.new(path: path, token: token, project: project, ref: ref)
              when '.xml'
                TestResults::JUnitTestResults.new(path: path, token: token, project: project, ref: ref)
              else
                raise "Unknown extension #{extension}"
              end

            yield test_results
          end
        end

        private

        attr_reader :file_glob, :token, :project, :ref
      end
    end
  end
end
