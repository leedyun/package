# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      # General purpose http mock server
      # see: https://smocker.dev/
      #
      class MockServer < Base
        DOCKER_IMAGE = "thiht/smocker"
        DOCKER_IMAGE_TAG = "0.18.2"

        def initialize
          super

          @tls = false
          @name = "smocker"
          @tls_path = "/etc/smocker/tls"
          @ports = [80, 8081]
          @environment = { "SMOCKER_MOCK_SERVER_LISTEN_PORT" => 80 }
          @tls_volume = { "smocker-ssl" => @tls_path }
        end

        attr_reader :name, :tls_volume
        attr_writer :tls

        def prepare
          super

          alpine_service_container.start_instance
          setup_tls if tls
        end

        def teardown!
          # Print smocker log output by using docker logs command because smocker only logs to stdout
          Docker::Command.execute("logs #{name}")
          # Remove alpine service container
          alpine_service_container.teardown!

          super
        end

        private

        attr_reader :tls_path, :tls

        # Run healthcheck validate startup of mock server
        #
        # @return [void]
        def wait_until_ready
          logger.info("Waiting for mock server to start!")
          poll_mock_healthcheck(3)
          logger.info("Mock server container is healthy!")
        end

        # Poll healthcheck endpoint
        #
        # @param [Integer] max_tries
        # @return [void]
        def poll_mock_healthcheck(max_tries)
          url = "#{tls ? 'https' : 'http'}://#{hostname}:8081/version"
          curl_cmd = "curl --cacert #{tls_path}/smocker.crt -s -f -o /dev/null -w '%{http_code}' #{url}"
          tries = 0

          loop do
            # Poll healthcheck endpoint and remove service container if it passes
            if docker.exec(alpine_service_container.name, curl_cmd, shell: "sh")
              alpine_service_container.teardown!
              break
            end
          rescue Support::ShellCommand::StatusError => e
            # re-raise StatusError so that built in startup retry is used in case of failure
            raise e if tries >= max_tries

            tries += 1
            sleep 1
          end
        end

        # Set up tls certs
        #
        # @return [void]
        def setup_tls
          @volumes = tls_volume
          @ports = [443, 8081]
          @environment = {
            "SMOCKER_MOCK_SERVER_LISTEN_PORT" => 443,
            "SMOCKER_TLS_ENABLE" => "true",
            "SMOCKER_TLS_CERT_FILE" => "#{tls_path}/smocker.crt",
            "SMOCKER_TLS_PRIVATE_KEY_FILE" => "#{tls_path}/smocker.key"
          }

          docker.copy(alpine_service_container.name, "#{CERTIFICATES_PATH}/smocker/.", tls_path)
        end

        # Helper container to run tls cert copy and curl healthcheck command
        # Separate container is required because tls certs have to be copied before smocker startup and smocker
        # container itself doesn't ship with curl to perform healthcheck requests
        #
        # @return [Component::Alpine]
        def alpine_service_container
          @alpine_service_container ||= Alpine.new.tap do |alpine|
            alpine.volumes = tls_volume
            alpine.network = network
          end
        end
      end
    end
  end
end
