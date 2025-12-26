# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class Base
        include Scenario::Actable

        CERTIFICATES_PATH = File.expand_path('../../../../tls_certificates', __dir__)

        attr_reader :docker, :logger
        attr_writer :name, :exec_commands
        attr_accessor :volumes,
          :ports,
          :network,
          :network_aliases,
          :environment,
          :runner_network,
          :airgapped_network,
          :additional_hosts,
          :secrets

        def initialize
          @docker = Docker::Engine.new
          @logger = Runtime::Logger.logger
          @environment = {}
          @volumes = {}
          @ports = []
          @network_aliases = []
          @exec_commands = []
          @additional_hosts = []
          @secrets = []
        end

        def add_network_alias(name)
          @network_aliases.push(name)
        end

        def name
          raise NotImplementedError, "#{self.class.name} must specify a default name"
        end

        def hostname
          "#{name}.#{network}"
        end

        def image
          return self.class.const_get(:DOCKER_IMAGE) if self.class.const_defined?(:DOCKER_IMAGE)

          raise NotImplementedError, "#{self.class.name} must specify a docker image as DOCKER_IMAGE"
        end

        def tag
          return self.class.const_get(:DOCKER_IMAGE_TAG) if self.class.const_defined?(:DOCKER_IMAGE_TAG)

          raise NotImplementedError, "#{self.class.name} must specify a docker image tag as DOCKER_IMAGE_TAG"
        end

        def start_instance
          instance_no_teardown
        end

        def instance(skip_teardown: false)
          instance_no_teardown do
            yield self if block_given?
          end
        ensure
          teardown unless skip_teardown
        end

        def ip_address
          docker.inspect(name) { |command| command << "-f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}'" }
        end

        alias_method :launch_and_teardown_instance, :instance

        def prepare
          prepare_docker_image
          prepare_docker_container
          prepare_network
        end

        def prepare_docker_image
          pull
        end

        def prepare_network
          prepare_airgapped_network
          prepare_runner_network
          return if docker.network_exists?(network)

          docker.network_create(network)
        end

        def prepare_airgapped_network
          return unless airgapped_network && !docker.network_exists?(network)

          docker.network_create("--driver=bridge --internal #{network}")
        end

        def prepare_runner_network
          return unless runner_network && !docker.network_exists?(runner_network)

          docker.network_create("--driver=bridge --internal #{runner_network}")
        end

        def prepare_docker_container
          return unless docker.container_exists?(name)

          docker.remove(name)
        end

        def start # rubocop:disable Metrics/AbcSize
          docker.run(image: image, tag: tag, mask_secrets: secrets) do |command|
            command << "-d"
            command << "--name #{name}"
            command << "--net #{network}"
            command << "--hostname #{hostname}"

            @ports.each do |mapping|
              command.port(mapping)
            end

            @volumes.to_h.each do |to, from|
              command.volume(to, from, 'Z')
            end

            command.volume(*log_volume.values) unless log_volume.empty?

            @environment.to_h.each do |key, value|
              command.env(key, value)
            end

            @network_aliases.to_a.each do |network_alias|
              command << "--network-alias #{network_alias}"
            end

            @additional_hosts.each do |host|
              command << "--add-host=#{host}"
            end
          end
        end

        def restart
          assert_name!

          docker.restart(name)
        end

        def teardown
          unless teardown?
            Runtime::Logger.info("The orchestrated docker containers have not been removed.")
            docker.ps

            return
          end

          teardown!
        end

        def teardown!
          assert_name!

          return unless docker.running?(name)

          docker.remove(name)
        end

        def pull
          return if Runtime::Env.skip_pull?

          docker.pull(image: image, tag: tag)
        end

        def process_exec_commands
          exec_commands.each { |command| docker.exec(name, command) }
        end

        private

        attr_reader :exec_commands, :wait_until_ready, :reconfigure

        def log_volume
          @log_volume ||= {
            src: File.join(Runtime::Env.host_artifacts_dir, name, 'logs'),
            dest: '/var/log/gitlab'
          }
        end

        def assert_name!
          raise 'Invalid instance name!' unless name
        end

        def instance_no_teardown # rubocop:disable Metrics/AbcSize
          begin
            retries ||= 0
            prepare
            start
            reconfigure
            wait_until_ready
            process_exec_commands
          rescue Support::ShellCommand::StatusError => e
            reconfigure_log_file = get_reconfigure_log_file_from_artefact
            # for scenarios where a service fails during startup, attempt to retry to avoid flaky failures
            if (retries += 1) < 3
              unless reconfigure_log_file.nil?
                Runtime::Logger.info(
                  "Follow the document " \
                  "https://gitlab.com/gitlab-org/quality/runbooks/-/blob/main/debug_orchestrated_test_locally/ " \
                  "for debugging the test failure locally.")

                # Tailing the reconfigure logs after retries are over and before raising exception
                Runtime::Logger.info("Tail of the reconfigure log file, see artifacts for full log: #{reconfigure_log_file}")
                Support::ShellCommand.new("tail -n 100 #{reconfigure_log_file}", stream_output: true).execute!
              end

              Runtime::Logger.warn(
                "Retry instance_no_teardown due to Support::ShellCommand::StatusError -- attempt #{retries}"
              )
              teardown!
              retry
            end

            # Printing logs to stdout for last retry failure

            if !reconfigure_log_file.nil? && retries == 3
              # Tailing the reconfigure logs after retries are over and before raising exception
              Runtime::Logger.info("Tail of the reconfigure log file, see artifacts for full log: #{reconfigure_log_file}")
              Support::ShellCommand.new("tail -n 100 #{reconfigure_log_file}", stream_output: true).execute!
            end

            raise e
          end

          yield self if block_given?
        end

        def teardown?
          !Runtime::Scenario.attributes.include?(:teardown) || Runtime::Scenario.teardown
        end
      end
    end
  end
end
