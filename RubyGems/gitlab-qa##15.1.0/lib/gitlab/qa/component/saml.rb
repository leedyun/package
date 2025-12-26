# frozen_string_literal: true

require 'securerandom'

# This component sets up the docker-test-saml-idp (https://github.com/kristophjunge/docker-test-saml-idp)
# image with the proper configuration for SAML integration.

module Gitlab
  module QA
    module Component
      class SAML < Base
        DOCKER_IMAGE = 'jamedjo/test-saml-idp'
        DOCKER_IMAGE_TAG = 'latest'

        def set_entity_id(entity_id)
          @environment['SIMPLESAMLPHP_SP_ENTITY_ID'] = entity_id
        end

        def set_assertion_consumer_service(assertion_con_service)
          @environment['SIMPLESAMLPHP_SP_ASSERTION_CONSUMER_SERVICE'] = assertion_con_service
        end

        def name
          @name ||= "saml-qa-idp"
        end

        def group_name
          @group_name ||= "saml_sso_group-#{SecureRandom.hex(4)}"
        end

        def instance
          raise 'Please provide a block!' unless block_given?

          super
        end

        # rubocop:disable Metrics/AbcSize
        def start
          docker.run(image: image, tag: tag) do |command|
            command << '-d '
            command << "--name #{name}"
            command << "--net #{network}"
            command << "--hostname #{hostname}"
            command << "--publish 8080:8080"
            command << "--publish 8443:8443"

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

        def set_sandbox_name(sandbox_name)
          ::Gitlab::QA::Runtime::Env.gitlab_sandbox_name = sandbox_name
        end

        def set_simple_saml_hostname
          ::Gitlab::QA::Runtime::Env.simple_saml_hostname = hostname
        end
      end
    end
  end
end
