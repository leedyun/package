# frozen_string_literal: true

require 'securerandom'

# This component sets up the docker-openldap (https://github.com/osixia/docker-openldap)
# image with the proper configuration for GitLab users to login.
#
# By default, the docker-openldap image configures the Docker image with a
# default admin user in the example.org domain. This user does not have a uid
# attribute that GitLab needs to authenticate, so we seed the LDAP server with
# a "tanuki" user via a LDIF file in the fixtures/ldap directory.
#
# The docker-openldap container has a startup script
# (https://github.com/osixia/docker-openldap/blob/v1.1.11/image/service/slapd/startup.sh#L74-L78)
# that looks for custom LDIF files in the BOOTSTRAP_LDIF directory. Note that the LDIF
# files must have a "changetype" option specified for the script to work.
module Gitlab
  module QA
    module Component
      class LDAP < Base
        DOCKER_IMAGE = 'osixia/openldap'
        DOCKER_IMAGE_TAG = 'latest'
        LDAP_USER = 'tanuki'
        LDAP_PASSWORD = 'password'
        BOOTSTRAP_LDIF = '/container/service/slapd/assets/config/bootstrap/ldif/custom'
        FIXTURE_PATH = File.expand_path('../../../../fixtures/ldap', __dir__)

        # LDAP_TLS is true by default
        def tls=(status)
          if status
            @environment['LDAP_TLS_CRT_FILENAME'] = "#{hostname}.crt"
            @environment['LDAP_TLS_KEY_FILENAME'] = "#{hostname}.key"
            @environment['LDAP_TLS_ENFORCE'] = 'true'
            @environment['LDAP_TLS_VERIFY_CLIENT'] = 'never'
          else
            @environment['LDAP_TLS'] = 'false'
          end
        end

        def username
          LDAP_USER
        end

        def password
          LDAP_PASSWORD
        end

        def name
          @name ||= "openldap-#{SecureRandom.hex(4)}"
        end

        def instance
          raise 'Please provide a block!' unless block_given?

          super
        end

        def prepare
          copy_fixtures
          @volumes["#{working_dir_tmp_fixture_path}/ldap"] = BOOTSTRAP_LDIF

          super
        end

        def teardown!
          FileUtils.rm_rf(working_dir_tmp_fixture_path)

          super
        end

        # rubocop:disable Metrics/AbcSize
        def start
          # copy-service needed for bootstraping LDAP user:
          # https://github.com/osixia/docker-openldap#seed-ldap-database-with-ldif
          docker.run(image: image, tag: tag, args: ['--copy-service']) do |command|
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
        # rubocop:enable Metrics/AbcSize

        def set_gitlab_credentials
          ::Gitlab::QA::Runtime::Env.ldap_username = username
          ::Gitlab::QA::Runtime::Env.ldap_password = password
        end

        private

        # Temporary fixture dir in working directory
        #
        # @return [String]
        def working_dir_tmp_fixture_path
          @local_fixture_path ||= Dir.mktmpdir('ldap', FileUtils.mkdir_p("#{Dir.pwd}/tmp"))
        end

        # Copy fixtures to current working directory
        # This is needed for docker-in-docker ci environments where mount points outside of build dir are not accessible
        #
        # @return [void]
        def copy_fixtures
          FileUtils.cp_r(FIXTURE_PATH, working_dir_tmp_fixture_path)
        end
      end
    end
  end
end
