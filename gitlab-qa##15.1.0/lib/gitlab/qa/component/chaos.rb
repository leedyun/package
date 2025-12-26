# frozen_string_literal: true

require 'json'

module Gitlab
  module QA
    module Component
      class Chaos < Base
        DOCKER_IMAGE = 'ghcr.io/shopify/toxiproxy'
        DOCKER_IMAGE_TAG = '2.5.0'

        def initialize
          super
          @network = Runtime::Env.docker_network
        end

        def name
          @name ||= "chaos"
        end

        def start
          prepare
          docker.run(image: image, tag: tag) do |command|
            command << '-d '
            command << "--name #{name}"
            command << "--network #{@network}"
            command << "--publish 8474:8474"
          end

          QA::Support::Shellout.shell <<~CMD
              docker run --network #{@network} --rm curlimages/curl:7.85.0 \
                -i -s \
                -X POST http://#{name}:8474/populate \
                -H 'Content-Type: application/json' \
                -d '#{proxies.to_json}'
          CMD
        end

        def proxies
          [
            {
              name: "postgres",
              listen: "[::]:5432",
              upstream: "postgres.test:5432",
              enabled: true
            },
            {
              name: "praefect",
              listen: "[::]:2305",
              upstream: "praefect.test:2305",
              enabled: true
            },
            {
              name: "gitaly1",
              listen: "[::]:8076",
              upstream: "gitaly1.test:8076",
              enabled: true
            },
            {
              name: "gitaly2",
              listen: "[::]:8077",
              upstream: "gitaly2.test:8077",
              enabled: true
            },
            {
              name: "gitaly3",
              listen: "[::]:8078",
              upstream: "gitaly3.test:8078",
              enabled: true
            }
          ]
        end
      end
    end
  end
end
