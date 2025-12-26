# frozen_string_literal: true

require 'nokogiri'
require 'json'
require 'active_support/core_ext/object/blank'

module GitlabQuality
  module TestTooling
    module Report
      class UpdateScreenshotPath
        def initialize(input_files:)
          @input_files = input_files
        end

        CONTAINER_PATH = File.join('/home', 'gitlab', 'qa', 'tmp').freeze

        def invoke!
          Dir.glob(input_files).each do |input_file|
            rewrite_screenshot_paths_in_junit_file(input_file) if input_file.end_with?('.xml')
            rewrite_screenshot_paths_in_json_file(input_file) if input_file.end_with?('.json')
          end
        end

        private

        attr_reader :input_files

        def rewrite_screenshot_paths_in_junit_file(junit_file)
          File.write(
            junit_file,
            rewrite_each_junit_screenshot_path(junit_file).to_s
          )

          puts "Saved #{junit_file}"
        end

        def rewrite_screenshot_paths_in_json_file(json_file)
          File.write(
            json_file,
            JSON.pretty_generate(
              rewrite_each_json_screenshot_path(json_file)
            )
          )

          puts "Saved #{json_file}"
        end

        def rewrite_each_junit_screenshot_path(junit_file)
          Nokogiri::XML(File.open(junit_file)).tap do |report|
            report.xpath('//system-out').each do |system_out|
              system_out.content = remove_container_absolute_path_prefix(system_out.content, test_artifacts_directory(junit_file))
            end
          end
        end

        def rewrite_each_json_screenshot_path(json_file)
          JSON.parse(File.read(json_file)).tap do |report|
            examples = report['examples']

            examples.each do |example|
              next unless example['screenshot'].present? && example['screenshot']['image'].present?

              example['screenshot']['image'] =
                remove_container_absolute_path_prefix(example.dig('screenshot', 'image'), test_artifacts_directory(json_file))
            end
          end
        end

        def remove_container_absolute_path_prefix(image_container_absolute_path, test_artifacts_dir)
          image_container_absolute_path.gsub(CONTAINER_PATH, test_artifacts_dir)
        end

        def test_artifacts_directory(filepath)
          File.dirname(filepath)
        end
      end
    end
  end
end
