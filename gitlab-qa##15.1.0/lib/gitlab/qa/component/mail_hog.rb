# frozen_string_literal: true

# This component sets up the MailHog (https://github.com/mailhog/MailHog)
# image with the proper configuration for SMTP email delivery from Gitlab

module Gitlab
  module QA
    module Component
      class MailHog < Base
        DOCKER_IMAGE = 'mailhog/mailhog'
        DOCKER_IMAGE_TAG = 'v1.0.0'

        def name
          @name ||= "mailhog"
        end

        def instance
          raise 'Please provide a block!' unless block_given?

          super
        end

        def start
          docker.run(image: image, tag: tag) do |command|
            command << '-d '
            command << "--name #{name}"
            command << "--net #{network}"
            command << "--hostname #{hostname}"
            command << "--publish 1025:1025"
            command << "--publish 8025:8025"
          end
        end

        def set_mailhog_hostname
          ::Gitlab::QA::Runtime::Env.mailhog_hostname = hostname
        end
      end
    end
  end
end
