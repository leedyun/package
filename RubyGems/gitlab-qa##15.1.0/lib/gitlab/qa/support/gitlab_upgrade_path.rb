# frozen_string_literal: true

require "active_support/core_ext/module/delegation"
require "yaml"

module Gitlab
  module QA
    module Support
      class GitlabUpgradePath
        # Get upgrade path between N - 1 and current version not including current release
        #
        # @param [String] current_version
        # @param [String] semver_component version number component for previous version detection - major|minor|patch
        # @param [String] edition GitLab edition - ee or ce
        def initialize(current_version, semver_component, edition)
          @version_info = GitlabVersionInfo.new(current_version, edition)
          @current_version = Gem::Version.new(current_version)
          @semver_component = semver_component
          @edition = edition
          @logger = Runtime::Logger.logger
        end

        # Get upgrade path between releases
        #
        # Return array with only previous version for updates from previous minor, patch versions
        #
        # @return [Array<QA::Release>]
        def fetch
          return minor_upgrade_path unless major_upgrade?

          major_upgrade_path
        rescue GitlabVersionInfo::VersionNotFoundError
          logger.error("Failed to construct gitlab upgrade path")
          raise
        end

        private

        delegate :latest_patch, to: :version_info

        attr_reader :version_info, :current_version, :semver_component, :edition, :logger

        # Upgrade path from previous minor version
        #
        # @return [Array]
        def minor_upgrade_path
          [release(latest_patch(previous_version))]
        end

        # Upgrade path from previous major version
        #
        # @return [Array]
        def major_upgrade_path
          # get versions between previous major and current version in gitlab upgrade path
          path = full_upgrade_path.each_with_object([]) do |ver, arr|
            next if ver <= previous_version || ver >= current_version

            arr << ver
          end

          [previous_version, *path].map do |ver|
            release(version_info.latest_patch(ver))
          end
        end

        # Upgrade from previous major
        #
        # @return [Boolean]
        def major_upgrade?
          semver_component == "major"
        end

        # Docker release image
        #
        # @param [String] version
        # @return [QA::Release]
        def release(version)
          QA::Release.new("gitlab/gitlab-#{edition}:#{version}-#{edition}.0")
        end

        # Previous gitlab version
        #
        # @return [Gem::Version]
        def previous_version
          @previous_version ||= version_info.previous_version(semver_component)
        end

        # Gitlab upgrade path
        #
        # @return [Array<Gem::Version>]
        def full_upgrade_path
          @full_upgrade_path ||= ::YAML
            .safe_load(upgrade_path_yml, symbolize_names: true)
            .map { |version| Gem::Version.new("#{version[:major]}.#{version[:minor]}") }
        end

        # Upgrade path yml
        #
        # @return [String]
        def upgrade_path_yml
          @upgrade_path_yml ||= begin
            logger.info("Fetching gitlab upgrade path from 'gitlab.com/gitlab-org/gitlab' project")
            HttpRequest.make_http_request(
              url: "https://gitlab.com/gitlab-org/gitlab/-/raw/master/config/upgrade_path.yml"
            ).body
          end
        end
      end
    end
  end
end
