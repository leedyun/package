# frozen_string_literal: true

require 'http'

module Gitlab
  module QA
    module Component
      # Component for the Selenoid Grid
      # https://aerokube.com/selenoid/latest/
      class Selenoid < Base
        DOCKER_IMAGE = 'aerokube/selenoid'
        DOCKER_IMAGE_TAG = 'latest-release'

        def name
          @name ||= 'selenoid'
        end

        def instance
          Runtime::Env.webdriver_headless = '0'
          Runtime::Env.chrome_disable_dev_shm = 'true'
          Runtime::Env.remote_grid = "#{hostname}:4444"
          Runtime::Env.remote_grid_protocol = 'http'
          raise 'Please provide a block!' unless block_given?

          super
        end

        def start
          pull_images
          docker.run(image: image, tag: tag, args:
                      ['-video-recorder-image',
                        QA::Runtime::Env.video_recorder_image,
                        '-container-network',
                        network,
                        '-timeout',
                        '10m0s']
          ) do |command|
            set_command_args(command)
            set_volumes(command)
          end
        end

        def wait_until_ready(max_attempts: 20, wait: 2)
          Runtime::Logger.info("Waiting for Selenoid ...")

          max_attempts.times do
            return Runtime::Logger.info("Selenoid ready!") if grid_healthy?

            sleep wait
          end

          raise "Retried #{max_attempts} times. Selenoid is not responding. Aborting."
        end

        private

        def grid_healthy?
          host = ENV['CI'] || ENV['CI_SERVER'] ? 'docker' : 'localhost'
          HTTP.get("http://#{host}:4444/ping").status&.success?
        rescue HTTP::ConnectionError => e
          Runtime::Logger.debug(e)
          false
        end

        def pull_images
          docker.pull(image: QA::Runtime::Env.selenoid_browser_image, tag: Runtime::Env.selenoid_browser_version)
          docker.pull(image: QA::Runtime::Env.video_recorder_image, tag: QA::Runtime::Env.video_recorder_version)
        end

        # Set custom run command arguments
        #
        # @param [Docker::Command] command
        # @return [void]
        def set_command_args(command)
          command << '-d '
          command << "--name #{name}"
          command << "--net #{network}"
          command << "--hostname #{hostname}"
          command << "--publish 4444:4444"
          command << "-e OVERRIDE_VIDEO_OUTPUT_DIR=#{Runtime::Env.selenoid_directory}/video"
        end

        # Set volumes
        #
        # @param [Docker::Command] command
        # @return [void]
        def set_volumes(command)
          command.volume('/var/run/docker.sock', '/var/run/docker.sock')
          command.volume("#{__dir__}/../../../../fixtures/selenoid", "/etc/selenoid")
          command.volume("#{Runtime::Env.selenoid_directory}/video", '/opt/selenoid/video')
        end
      end
    end
  end
end
