# frozen_string_literal: true

require 'optparse'
require 'active_support/inflector'

module Gitlab
  module QA
    # rubocop:disable Metrics/AbcSize
    class Runner
      def self.run(args)
        Runtime::Scenario.define(:teardown, true)
        Runtime::Scenario.define(:run_tests, true)
        Runtime::Scenario.define(:qa_image, Runtime::Env.qa_image) if Runtime::Env.qa_image
        Runtime::Scenario.define(:omnibus_configuration, Runtime::OmnibusConfiguration.new)
        Runtime::Scenario.define(:seed_db, false)
        Runtime::Scenario.define(:seed_admin_token, true) # Create an admin access token for root user by default
        Runtime::Scenario.define(:omnibus_exec_commands, [])
        Runtime::Scenario.define(:skip_server_hooks, false)

        # Omnibus Configurators specified by flags
        @active_configurators = []
        @seed_scripts = []
        @omnibus_configurations = %w[default] # always load default configuration

        @options = OptionParser.new do |opts|
          opts.banner = 'Usage: gitlab-qa Scenario URL [options] [[--] path] [rspec_options]'

          opts.on('--no-teardown', 'Skip teardown of containers after the scenario completes.') do
            Runtime::Scenario.define(:teardown, false)
          end

          opts.on('--no-tests',
            'Orchestrates the docker containers but does not run the tests. Implies --no-teardown') do
            Runtime::Scenario.define(:run_tests, false)
            Runtime::Scenario.define(:teardown, false)
          end

          opts.on('--no-admin-token', 'Skip admin token creation for root user') do
            Runtime::Scenario.define(:seed_admin_token, false)
          end

          opts.on('--skip-server-hooks', 'Skip adding global git server hooks') do
            Runtime::Scenario.define(:skip_server_hooks, true)
          end

          opts.on(
            '--qa-image QA_IMAGE',
            String,
            "Specifies a QA image to be used instead of inferring it from the GitLab image." \
            "See Gitlab::QA::Release#qa_image"
          ) do |value|
            Runtime::Scenario.define(:qa_image, value)
          end

          opts.on_tail('-v', '--version', 'Show the version') do
            require 'gitlab/qa/version'
            puts "#{$PROGRAM_NAME} : #{VERSION}"
            exit
          end

          opts.on('--omnibus-config config1[,config2,...]', 'Use Omnibus Configuration package') do |configuration|
            configuration.split(',').map do |config|
              @omnibus_configurations << config
            end
          end

          opts.on('--seed-db search_pattern1[,search_pattern2,...]',
            'Seed application database with sample test data') do |file_pattern|
            file_pattern.split(',').each do |pattern|
              @seed_scripts << pattern
            end

            Runtime::Scenario.define(:seed_db, @seed_scripts)
          end

          opts.on_tail('-h', '--help', 'Show the usage') do
            puts opts
            exit
          end

          begin
            opts.parse(args)
          rescue OptionParser::InvalidOption
            # Ignore invalid options and options that are passed through to the tests
          end
        end

        # Remove arguments passed into GitLab QA preventing them from being
        # passed into the specs
        args = remove_gitlab_qa_args(args)

        if args.size >= 1
          scenario = Scenario.const_get(args.shift)

          load_omnibus_configurations

          begin
            @active_configurators.compact.each do |configurator|
              configurator.instance(skip_teardown: true)
            end

            scenario.perform(*args)
          ensure
            @active_configurators.compact.each(&:teardown)
          end
        else
          puts @options
          exit 1
        end
      end

      def self.gitlab_qa_options
        @gitlab_qa_options ||= @options.top.list
      end

      # Take a set of arguments and remove them from the set of
      # predefined GitLab QA arguments
      # @param args Array the arguments to parse through and remove GitLab QA opts
      # @return Arguments to be passed ultimately to the RSpec runner
      def self.remove_gitlab_qa_args(args)
        args.each_with_index do |arg, i|
          gitlab_qa_options.each do |opt|
            next unless opt.long.flatten.first == arg

            args[i] = nil
            args[i + 1] = nil if opt.is_a? OptionParser::Switch::RequiredArgument
          end
        end.compact
      end

      def self.load_omnibus_configurations
        # OmnibusConfiguration::Test       => --test
        # OmnibusConfiguration::HelloThere => --hello_there
        @omnibus_configurations.uniq.each do |config|
          Runtime::OmnibusConfigurations.const_get(config.camelize).new.tap do |configurator|
            @active_configurators << configurator.prepare

            # */etc/gitlab/gitlab.rb*
            # -----------------------
            # # Runtime::OmnibusConfiguration::Packages
            # gitlab_rails['packages_enabled'] = true
            Runtime::Scenario.omnibus_configuration << "# #{configurator.class.name}"
            Runtime::Scenario.omnibus_exec_commands << configurator.exec_commands

            # Load the configuration
            Runtime::Scenario.omnibus_configuration << configurator.configuration
          end
        rescue NameError
          raise <<~ERROR
            Invalid Omnibus Configuration `#{config}`.
            Possible configurations: #{Runtime::OmnibusConfigurations.constants.map { |c| c.to_s.underscore }.join(',')}"
          ERROR
        end
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
