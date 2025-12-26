# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class PostgreSQL < Base
        DOCKER_IMAGE = 'postgres'
        DOCKER_IMAGE_TAG = '11'

        def name
          @name ||= "postgres"
        end

        def start
          @docker.run(image: image, tag: tag) do |command|
            command << "-d"
            command << "--name #{name}"
            command << "--net #{network}"

            command.env("POSTGRES_PASSWORD", "SQL_PASSWORD")
          end
        end

        def run_psql(command)
          @docker.exec(name, %(psql -U postgres #{command}))
        end

        private

        def wait_until_ready
          start = Time.now
          begin
            run_psql 'template1'
          rescue StandardError
            sleep 5
            retry if Time.now - start < 60
            raise
          end
        end
      end
    end
  end
end
