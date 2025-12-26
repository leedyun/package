# frozen_string_literal: true

# frozen_string_literal

require 'optparse'
require 'fileutils'
require_relative 'options'

module Gitlab
  module Triage
    class OptionParser
      class << self
        # rubocop:disable Metrics/AbcSize
        def parse(argv)
          options = Options.new
          options.host_url = 'https://gitlab.com'

          parser = ::OptionParser.new do |opts|
            opts.banner = "Usage: gitlab-triage [options]\n\n"

            opts.on('-n', '--dry-run', "Don't actually update anything, just print") do |value|
              options.dry_run = value
            end

            opts.on('-f', '--policies-file [string]', String, 'A valid policies YML file') do |value|
              options.policies_files << value
            end

            opts.on('--all-projects', 'Process all projects the token has access to') do |value|
              options.all = value
            end

            opts.on('-s', '--source [type]', [:projects, :groups], 'The source type between [ projects or groups ], default value: projects') do |value|
              options.source = value
            end

            opts.on('-i', '--source-id [string]', String, 'Source ID or path') do |value|
              options.source_id = value
            end

            opts.on('-p', '--project-id [string]', String, '[Deprecated] A project ID or path, please use `--source-id`') do |value|
              puts Gitlab::Triage::UI.warn("The option `--project-id` has been deprecated, please use `--source-id` instead")
              puts
              options.source = 'projects'
              options.source_id = value
            end

            opts.on('--resource-reference [string]', String, 'Resource short-reference, e.g. #42, !33, or &99') do |value|
              options.resource_reference = value
            end

            opts.on('-t', '--token [string]', String, 'A valid API token') do |value|
              options.token = value
            end

            opts.on('-H', '--host-url [string]', String, 'A valid host url') do |value|
              options.host_url = value
            end

            opts.on('-r', '--require [string]', String, 'Require a file before performing') do |value|
              options.require_files << value
            end

            opts.on('-d', '--debug', 'Print debug information') do |value|
              options.debug = value
            end

            opts.on('-h', '--help', 'Print help message') do
              $stdout.puts opts
              exit # rubocop:disable Rails/Exit
            end

            opts.on('-v', '--version', 'Print version') do
              require_relative 'version'
              $stdout.puts Gitlab::Triage::VERSION
              exit # rubocop:disable Rails/Exit
            end

            opts.on('--init', 'Initialize the project with a policy file') do
              example_path =
                File.expand_path('../../../support/.triage-policies.example.yml', __dir__)

              FileUtils.cp(example_path, '.triage-policies.yml')
              exit # rubocop:disable Rails/Exit
            end

            opts.on('--init-ci', 'Initialize the project with a .gitlab-ci.yml file') do
              example_path =
                File.expand_path('../../../support/.gitlab-ci.example.yml', __dir__)

              FileUtils.cp(example_path, '.gitlab-ci.yml')
              exit # rubocop:disable Rails/Exit
            end
          end

          parser.parse!(argv)

          options.source = nil if options.all
          options.token ||= ''

          options
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
