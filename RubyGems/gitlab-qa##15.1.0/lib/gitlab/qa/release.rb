# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module Gitlab
  module QA
    class Release
      CANONICAL_REGEX = /
        \A
          (?<edition>ce|ee|jh)
          (-qa)?
          (:(?<tag>.+))?
        \z
      /xi
      CUSTOM_GITLAB_IMAGE_REGEX = %r{
        \A
          (?<image_without_tag>
            (?<registry>[^/:]+(:(?<port>\d+))?)
            (?<project>.+)
            gitlab-
            (?<edition>ce|ee|jh)
          )
          (-qa)?
          (:(?<tag>.+))?
        \z
      }xi

      delegate :ci_project_path, to: Gitlab::QA::Runtime::Env

      # Official dev tag example:
      #  12.5.4(-rc42)-ee
      # |-------------|--|
      #   |             |
      #   |             |
      #   |             |
      #   |          edition
      # version
      DEV_OFFICIAL_TAG_REGEX = /
        \A
          (?<version>\d+\.\d+.\d+(?:-rc\d+)?)-(?<edition>ce|ee|jh)
        \z
      /xi

      # Dev tag example:
      #  12.1.201906121026-325a6632895.b340d0bd35d
      # |----|------------|-----------|-----------|
      #   |         |           |           |
      #   |         |           |      omnibus-ref
      #   |         |       gitlab-ee ref
      #   |     timestamp
      # version
      DEV_TAG_REGEX = /
        \A
          (?<version>\d+\.\d+(.\d+)?)\.(?<timestamp>\d+)-(?<gitlab_ref>[A-Za-z0-9]+)\.(?<omnibus_ref>[A-Za-z0-9]+)
        \z
      /xi

      DEFAULT_TAG = 'latest'
      DEFAULT_CANONICAL_TAG = 'nightly'
      DEV_REGISTRY = Gitlab::QA::Runtime::Env.qa_dev_registry
      COM_REGISTRY = Gitlab::QA::Runtime::Env.qa_com_registry

      InvalidImageNameError = Class.new(RuntimeError)

      attr_reader :release
      attr_writer :tag

      def initialize(release)
        @release = release.to_s.downcase
        return if valid?

        raise InvalidImageNameError, "The release image name '#{@release}' does not have the expected format."
      end

      def to_s
        "#{image}:#{tag}"
      end

      def previous_stable
        # The previous stable is always gitlab/gitlab-ce:latest or
        # gitlab/gitlab-ee:latest
        self.class.new("#{canonical_image}:latest")
      end

      def edition
        @edition ||=
          if canonical?
            release.match(CANONICAL_REGEX)[:edition].to_sym
          else
            release.match(CUSTOM_GITLAB_IMAGE_REGEX)[:edition].to_sym
          end
      end

      def ee?
        edition == :ee
      end

      def to_ee
        return self if ee?

        self.class.new(to_s.sub('ce:', 'ee:'))
      end

      def image
        @image ||=
          if canonical?
            "gitlab/gitlab-#{edition}"
          else
            release.match(CUSTOM_GITLAB_IMAGE_REGEX)[:image_without_tag]
          end
      end

      def qa_image
        @qa_image ||= if omnibus_mirror?
                        omnibus_project = image.match(CUSTOM_GITLAB_IMAGE_REGEX)[:project]
                        gitlab_project = ci_project_path ? "/#{ci_project_path}/" : "/gitlab-org/gitlab/"

                        "#{image.gsub(omnibus_project, gitlab_project)}-qa"
                      else
                        "#{image}-qa"
                      end
      end

      def project_name
        @project_name ||=
          if canonical?
            "gitlab-#{edition}"
          else
            "gitlab-#{release.match(CUSTOM_GITLAB_IMAGE_REGEX)[:edition]}"
          end
      end

      # Tag scheme for gitlab-{ce,ee} images is like 11.1.0-rc12.ee.0
      def tag
        @tag ||=
          if canonical?
            release.match(CANONICAL_REGEX)[:tag] || DEFAULT_CANONICAL_TAG
          else
            release.match(CUSTOM_GITLAB_IMAGE_REGEX)&.[](:tag) || DEFAULT_TAG
          end
      end

      # Tag scheme for gitlab-{ce,ee}-qa images is like 11.1.0-rc12-ee
      def qa_tag
        if dev_gitlab_org? && (match_data = tag.match(DEV_TAG_REGEX))
          match_data[:gitlab_ref]
        else
          tag.sub(/[-.]([ce]e)(\.(\d+))?\z/, '-\1')
        end
      end

      def login_params
        return if Runtime::Env.skip_pull?

        params = if dev_gitlab_org?
                   Runtime::Env.require_qa_dev_access_token!

                   {
                     username: Runtime::Env.gitlab_dev_username,
                     password: Runtime::Env.dev_access_token_variable,
                     registry: DEV_REGISTRY
                   }
                 elsif omnibus_mirror? || omnibus_security?
                   omnibus_login_params
                 end

        populate_registry_env_vars(params)
      end

      def populate_registry_env_vars(params)
        if params
          Runtime::Env.release_registry_url = params[:registry]
          Runtime::Env.release_registry_username = params[:username]
          Runtime::Env.release_registry_password = params[:password]
        end

        params
      end

      def omnibus_login_params
        username, password = if Runtime::Env.ci_job_token && Runtime::Env.ci_pipeline_source.include?('pipeline')
                               ['gitlab-ci-token', Runtime::Env.ci_job_token]
                             elsif Runtime::Env.qa_container_registry_access_token
                               [Runtime::Env.gitlab_username, Runtime::Env.qa_container_registry_access_token]
                             else
                               Runtime::Env.require_qa_access_token!

                               [Runtime::Env.gitlab_username, Runtime::Env.qa_access_token]
                             end

        {
          username: username,
          password: password,
          registry: COM_REGISTRY
        }
      end

      def dev_gitlab_org?
        image.start_with?(DEV_REGISTRY)
      end

      def omnibus_mirror?
        image.start_with?("#{COM_REGISTRY}/gitlab-org/build/omnibus-gitlab-mirror/")
      end

      def omnibus_security?
        image.start_with?("#{COM_REGISTRY}/gitlab-org/security/omnibus-gitlab/")
      end

      def valid?
        canonical? || release.match?(CUSTOM_GITLAB_IMAGE_REGEX)
      end

      def api_project_name
        project_name.gsub('ce', 'foss').gsub('-ee', '')
      end

      private

      def canonical?
        release =~ CANONICAL_REGEX
      end

      def canonical_image
        @canonical_image ||= "gitlab/gitlab-#{edition}"
      end
    end
  end
end
