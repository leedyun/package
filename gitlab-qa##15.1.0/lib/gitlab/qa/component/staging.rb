# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

module Gitlab
  module QA
    module Component
      class Staging
        ADDRESS = Runtime::Env.staging_url
        GEO_SECONDARY_ADDRESS = Runtime::Env.geo_staging_url

        def self.release
          QA::Release.new(image)
        rescue Support::InvalidResponseError => e
          warn e.message
          warn "#{e.response.code} #{e.response.message}: #{e.response.body}"
          exit 1
        end

        def self.image
          # QA images are tagged with the following logic
          # 1. For auto-deploy versions, they are tagged with their corresponding commit SHA
          #    That is, if auto-deploy version is `15.4.202209150620+70251a89db4.a625f183e2e`,
          #    the QA image tag will be `70251a89db4`
          # 2. For stable/RC versions, they are tagged with the version with `v` prefix.
          #    That is, if the version is `15.3.3-ee`, the QA image tag will be `v15.3.3-ee`
          # These images are available from the GitLab project's container registry.

          # If token to access dev.gitlab.org registry is provided, we will
          # fetch from there. Else, we will try to fetch from GitLab.com
          # registry.
          if Runtime::Env.dev_access_token_variable
            "dev.gitlab.org:5005/gitlab/gitlab-ee/gitlab-ee-qa:#{tag}"
          else
            "registry.gitlab.com/gitlab-org/gitlab/gitlab-ee-qa:#{tag}"
          end
        end

        def self.address
          self::ADDRESS
        end

        def self.tag
          @tag ||= Version.new(address).tag
        end

        class Version
          attr_reader :uri

          def initialize(address)
            @uri = URI.join(address, '/api/v4/version')

            Runtime::Env.require_qa_access_token!
          end

          def tag
            if official?
              # Because RCs are considered to be pre-releases, that come before
              # regular releases we can't check if version < 15.6.0, hence
              # using this weird not-gonna-happen-patch-release hack.
              Gem::Version.new(version) > Gem::Version.new('15.5.99') ? version : "v#{version}"
            else
              revision
            end
          end

          private

          def official?
            QA::Release::DEV_OFFICIAL_TAG_REGEX.match?(version)
          end

          def revision
            api_get!.fetch('revision')
          end

          def version
            api_get!.fetch('version')
          end

          def api_get!
            @response_body ||=
              begin
                response = Support::GetRequest.new(uri, Runtime::Env.qa_access_token).execute!
                JSON.parse(response.body)
              end
          end
        end
      end
    end
  end
end
