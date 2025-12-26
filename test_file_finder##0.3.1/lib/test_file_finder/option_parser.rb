# frozen_string_literal: true

require 'optparse'

module TestFileFinder
  Options = Struct.new(:mapping_file, :json, :project_path, :merge_request_iid)

  class OptionParser
    def self.parse!(argv)
      Options.new.tap do |options|
        ::OptionParser.new do |opts|
          opts.banner = "Usage: tff [options] [...file_paths]"

          opts.on('-f', '--mapping-file FILE', String, 'Use a custom test mapping file') do |mapping_file|
            options.mapping_file = mapping_file
          end

          opts.on('--yaml FILE', String, 'Use a YAML test mapping file') do |mapping_file|
            options.mapping_file = mapping_file
          end

          opts.on('--json FILE', String, 'Use a JSON mapping file') do |json|
            options.json = json
          end

          opts.on('--project-path PROJECT_PATH', String,
            'Path of GitLab project, e.g `gitlab-org/gitlab`') do |project_path|
            options.project_path = project_path
          end

          opts.on('--merge-request-iid MERGE_REQUEST_IID', Integer, 'Merge request internal id') do |merge_request_iid|
            options.merge_request_iid = merge_request_iid
          end
        end.parse!(argv)
      end
    end
  end
end
