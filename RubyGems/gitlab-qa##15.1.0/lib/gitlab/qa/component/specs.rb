# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize

require 'securerandom'
require 'active_support/core_ext/array/grouping'

module Gitlab
  module QA
    module Component
      ##
      # This class represents GitLab QA specs image that is implemented in
      # the `qa/` directory located in GitLab CE / EE repositories.
      #
      class Specs < Scenario::Template
        LAST_RUN_FILE = "examples.txt"

        attr_accessor :suite,
          :release,
          :network,
          :args,
          :volumes,
          :env,
          :runner_network,
          :hostname,
          :additional_hosts,
          :retry_failed_specs,
          :infer_qa_image_from_release

        def initialize
          @docker = Docker::Engine.new(stream_output: true) # stream test output directly instead of through logger
          @env = {}
          @volumes = {}
          @additional_hosts = []
          @volumes = { '/var/run/docker.sock' => '/var/run/docker.sock' }
          @retry_failed_specs = Runtime::Env.retry_failed_specs?

          include_optional_volumes(Runtime::Env.qa_rspec_report_path => 'rspec')
        end

        def perform
          if Runtime::Env.use_selenoid?
            Component::Selenoid.perform do |selenoid|
              selenoid.network = network
              selenoid.instance do
                internal_perform
              end
            end
          else
            internal_perform
          end
        end

        def internal_perform
          return Runtime::Logger.info("Skipping tests.") if skip_tests?

          raise ArgumentError unless [suite, release].all?

          docker_pull_qa_image_if_needed

          Runtime::Logger.info("Running test suite `#{suite}` for #{release.project_name}")

          name = "#{release.project_name}-qa-#{SecureRandom.hex(4)}"
          run_specs(name)
        rescue Support::ShellCommand::StatusError => e
          raise e unless retry_failed_specs

          Runtime::Logger.warn("Initial test run failed, attempting to retry failed specs in new process!")
          results_file = File.join(host_artifacts_dir(name), LAST_RUN_FILE)
          raise e unless valid_last_run_file?(results_file)

          Runtime::Logger.debug("Found initial run results file '#{results_file}', retrying failed specs!")
          run_specs(name, retry_process: true, initial_run_results_host_path: results_file)
        end

        private

        # Ful path to tmp dir inside container
        #
        # @return [String]
        def tmp_dir
          @tmp_dir ||= File.join(Docker::Volumes::QA_CONTAINER_WORKDIR, 'tmp')
        end

        def feature_flag_sets
          return @feature_flag_sets if defined?(@feature_flag_sets)

          feature_flag_sets = []
          # When `args` includes:
          #   `[..., "--disable-feature", "a", "--enable-feature", "b", "--set-feature-flags", "c=enable", ...]`
          # `feature_flag_sets` will be set to:
          #   `[["--disable-feature", "a"], ["--enable-feature", "b"], ["--set-feature-flags", "c=enable"]]`
          # This will result in tests running three times, once with each feature flag option.
          while (index = args&.index { |x| x =~ /--.*-feature/ })
            feature_flag_sets << args.slice!(index, 2)
          end
          # When `args` do not have any feature flag options, we add [] so that test is run exactly once.
          feature_flag_sets << [] unless feature_flag_sets.any?

          @feature_flag_sets = feature_flag_sets
        end

        def run_specs(name, retry_process: false, initial_run_results_host_path: nil)
          container_name = retry_process ? "#{name}-retry" : name

          env_vars = if retry_process
                       Runtime::Env.variables.merge({
                         **env,
                         "QA_RSPEC_RETRIED" => "true",
                         "NO_KNAPSACK" => "true"
                       })
                     else
                       Runtime::Env.variables.merge(env)
                     end

          env_vars["RSPEC_LAST_RUN_RESULTS_FILE"] = last_run_results_file

          run_volumes = volumes.to_h.merge({ host_artifacts_dir(container_name) => tmp_dir })
          run_volumes[initial_run_results_host_path] = last_run_results_file if retry_process

          feature_flag_sets.each do |feature_flag_set|
            @docker.run(
              image: qa_image,
              args: [suite, *args_with_flags(feature_flag_set, retry_process: retry_process)],
              mask_secrets: Runtime::Env.variables_to_mask
            ) do |command|
              command << "-t --rm --net=#{network || 'bridge'}"

              unless hostname.nil?
                command << "--hostname #{hostname}"
                command.env('QA_HOSTNAME', hostname)
              end

              if Runtime::Env.docker_add_hosts.present? || additional_hosts.present?
                hosts = Runtime::Env.docker_add_hosts.concat(additional_hosts).map { |host| "--add-host=#{host} " }.join
                command << hosts # override /etc/hosts in docker container when test runs
              end

              env_vars.each { |key, value| command.env(key, value) }
              run_volumes.each { |to, from| command.volume(to, from) }

              command.name(container_name)
            end
          end
        end

        def docker_pull_qa_image_if_needed
          @docker.login(**release.login_params) if release.login_params

          @docker.pull(image: qa_image) unless Runtime::Env.skip_pull?
        end

        def args_with_flags(feature_flag_set, retry_process: false)
          return args if feature_flag_set.empty? && !retry_process

          run_args = if !retry_process
                       args.dup
                     elsif args.include?("--")
                       qa_args, rspec_args = args.split("--")
                       [*qa_args, "--"] + args_without_spec_arguments(rspec_args).push("--only-failures")
                     else
                       args.dup.push("--", "--only-failures")
                     end

          return run_args if feature_flag_set.empty?

          Runtime::Logger.info("Running with feature flag: #{feature_flag_set.join(' ')}")
          run_args.insert(1, *feature_flag_set)
        end

        # Remove particular spec argument like specific spec/folder or specific tags
        #
        # @param [Array] rspec_args
        # @return [Array]
        def args_without_spec_arguments(rspec_args)
          arg_pairs = rspec_args.flatten.each_with_object([]) do |arg, new_args|
            next new_args.push([arg]) if new_args.last.nil? || arg.start_with?("--") || new_args.last.size == 2

            new_args.last.push(arg)
          end

          arg_pairs.reject { |pair| pair.first == "--tag" || !pair.first.start_with?("--") }.flatten
        end

        def skip_tests?
          Runtime::Scenario.attributes.include?(:run_tests) && !Runtime::Scenario.run_tests
        end

        def qa_image
          infered_qa_image = "#{release.qa_image}:#{release.qa_tag}"
          return infered_qa_image if infer_qa_image_from_release || !Runtime::Scenario.attributes.include?(:qa_image)

          Runtime::Scenario.qa_image
        end

        # Adds volumes to the volumes hash if the relevant host paths exist
        #
        # @param [Array] *args volume host_path => container_path pairs
        # @return [void]
        def include_optional_volumes(args)
          args.each do |host_path, container_path|
            host_path.present? && volumes[host_path] = File.join(Docker::Volumes::QA_CONTAINER_WORKDIR, container_path)
          end
        end

        # Full path to host artifacts dir
        #
        # @param [String] name
        # @return [String]
        def host_artifacts_dir(name)
          File.join(Runtime::Env.host_artifacts_dir, name)
        end

        # Path to save or read run results file within container
        #
        # @return [String]
        def last_run_results_file
          File.join(tmp_dir, LAST_RUN_FILE)
        end

        # Validate rspec last run file
        #
        # @param [String] results_file
        # @return [Boolean]
        def valid_last_run_file?(results_file)
          unless File.exist?(results_file)
            Runtime::Logger.error("Failed to find initial run results file '#{results_file}', aborting retry!")
            return false
          end

          unless File.read(results_file).include?("failed")
            Runtime::Logger.error(
              "Initial run results file '#{results_file}' does not contain any failed tests, aborting retry!"
            )

            return false
          end

          true
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
