# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class Elasticsearch < Base
        DOCKER_IMAGE = 'docker.elastic.co/elasticsearch/elasticsearch'

        def name
          @name ||= "elastic68"
        end

        def tag
          Runtime::Env.elastic_version
        end

        def start
          @docker.run(image: image, tag: tag) do |command|
            command << "-d"
            command << "--name #{name}"
            command << "--net #{network}"
            command << "--publish 9200:9200"
            command << "--publish 9300:9300"

            command.env("discovery.type", "single-node")
            command.env("ES_JAVA_OPTS", "-Xms512m -Xmx512m")
            command.env("xpack.security.enabled", "false")
          end
        end
      end
    end
  end
end
