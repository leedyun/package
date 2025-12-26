# frozen_string_literal: true

require 'securerandom'
require 'fileutils'
require 'yaml'

# This component sets up the Minio (https://hub.docker.com/r/minio/minio)
# image with the proper configuration for GitLab users to use object storage.
module Gitlab
  module QA
    module Component
      class Minio < Base
        DOCKER_IMAGE = 'minio/minio'
        DOCKER_IMAGE_TAG = 'latest'
        # These are secrets used in a local Minio container, they're not used for any online S3 server.
        AWS_ACCESS_KEY = 'AKIAIOSFODNN7EXAMPLE'
        AWS_SECRET_KEY = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
        DATA_DIR = '/data'
        DEFAULT_PORT = 9000

        def initialize
          super

          @environment = { MINIO_ROOT_USER: AWS_ACCESS_KEY, MINIO_ROOT_PASSWORD: AWS_SECRET_KEY }
          @volumes = { host_data_dir => DATA_DIR }
          @buckets = []
        end

        def add_bucket(name)
          @buckets << name
        end

        def to_config
          YAML.safe_load <<~CFG
            provider: AWS
            aws_access_key_id: #{AWS_ACCESS_KEY}
            aws_secret_access_key: #{AWS_SECRET_KEY}
            aws_signature_version: 4
            host: #{hostname}
            endpoint: http://#{hostname}:#{port}
            path_style: true
          CFG
        end

        private

        def host_data_dir
          base_dir = ENV['CI_PROJECT_DIR'] || '/tmp'

          File.join(base_dir, 'minio')
        end

        def name
          @name ||= "minio-#{SecureRandom.hex(4)}"
        end

        def port
          DEFAULT_PORT
        end

        def prepare
          super

          FileUtils.mkdir_p(host_data_dir)

          @buckets.each do |bucket|
            Runtime::Logger.info("Creating Minio bucket: #{bucket}")
            FileUtils.mkdir_p(File.join(host_data_dir, bucket))
          end
        end

        def start # rubocop:disable Metrics/AbcSize
          # --compat needed until https://gitlab.com/gitlab-org/gitlab-workhorse/issues/210
          # is resolved
          docker.run(image: image, tag: tag, args: ["server", "--compat", DATA_DIR]) do |command|
            command << '-d '
            command << "--name #{name}"
            command << "--net #{network}"
            command << "--hostname #{hostname}"

            @volumes.to_h.each do |to, from|
              command.volume(to, from, 'Z')
            end

            @environment.to_h.each do |key, value|
              command.env(key, value)
            end

            @network_aliases.to_a.each do |network_alias|
              command << "--network-alias #{network_alias}"
            end
          end
        end
      end
    end
  end
end
