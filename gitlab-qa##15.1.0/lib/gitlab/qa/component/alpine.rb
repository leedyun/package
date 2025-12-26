# frozen_string_literal: true

require "securerandom"

module Gitlab
  module QA
    module Component
      # Generic helper component running alpine linux image
      # Useful for populating volumes beforehand or running any other action that requires a running container
      # and has to be performed before main component containers are started
      #
      class Alpine < Base
        DOCKER_IMAGE = "alpine/curl"
        DOCKER_IMAGE_TAG = "latest"

        def name
          @name ||= "alpine-#{SecureRandom.hex(4)}"
        end

        def start
          docker.run(image: image, tag: tag, args: ["tail", "-f", "/dev/null"]) do |command|
            command << "-d"
            command << "--name #{name}"
            command << "--network #{network}" if network

            volumes.each { |to, from| command.volume(to, from, 'Z') }
            environment.each { |key, value| command.env(key, value) }
          end
        end

        def prepare
          prepare_docker_container
        end
      end
    end
  end
end
