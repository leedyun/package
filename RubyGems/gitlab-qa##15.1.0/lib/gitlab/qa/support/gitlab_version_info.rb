# frozen_string_literal: true

module Gitlab
  module QA
    module Support
      class GitlabVersionInfo
        VERSION_PATTERN = /^(?<version>\d+\.\d+\.\d+)/
        COMPONENT_PATTERN = /^(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)/

        VersionNotFoundError = Class.new(RuntimeError)

        # Get previous gitlab version
        #
        # @param [String] current_version
        # @param [String] edition GitLab edition - ee or ce
        def initialize(current_version, edition)
          @current_version = current_version
          @edition = edition
          @logger = Runtime::Logger.logger
        end

        # Get N - 1 version number
        #
        # @param [String] semver_component version number component for previous version detection - major|minor|patch
        # @return [Gem::Version]
        def previous_version(semver_component)
          case semver_component
          when "major"
            previous_major
          when "minor"
            previous_minor
          when "patch"
            previous_patch
          else
            raise("Unsupported semver component, must be major|minor|patch")
          end
        end

        # Get latest patch for specific version number
        #
        # @example
        # latest_patch(Gem::Version.new("14.10")) => "14.10.5"
        # latest_patch(Gem::Version.new("14.10.5")) => "14.10.5"
        #
        # @param [Gem::Version] version
        # @return [String]
        def latest_patch(version)
          # check if version is already a patch version
          return version if version.to_s.split('.').size == 3

          versions.find { |ver| ver.to_s.match?(/^#{version}\./) }.tap do |ver|
            raise_version_not_found("Latest patch version for version #{version}") unless ver
          end
        end

        private

        MAX_TAGS_HTTP_REQUESTS = 50
        # https://docs.docker.com/docker-hub/api/latest/#tag/images/operation/GetNamespacesRepositoriesImages
        TAGS_PER_PAGE = 100

        attr_reader :current_version, :edition, :logger

        # Current versions major version
        #
        # @return [Integer]
        def current_major
          @current_major ||= current_version.match(COMPONENT_PATTERN)[:major].to_i
        end

        # Current versions minor version
        #
        # @return [Integer]
        def current_minor
          @current_minor ||= current_version.match(COMPONENT_PATTERN)[:minor].to_i
        end

        # Current versions patch version
        #
        # @return [Integer]
        def current_patch
          @current_patch ||= current_version.match(COMPONENT_PATTERN)[:patch].to_i
        end

        # Previous major version
        #
        # @return [String]
        def previous_major
          return fallback_major unless tags

          versions.find { |version| version.to_s.start_with?((current_major - 1).to_s) }
        end

        # Previous first major version image
        #
        # @return [String]
        def fallback_major
          previous_fallback_version(current_major - 1)
        end

        # Previous minor version
        #
        # @return [String]
        def previous_minor
          return fallback_minor unless tags
          return previous_major if current_minor.zero?

          versions.find { |version| version.to_s.match?(/^#{current_major}\.#{current_minor - 1}/) }.tap do |ver|
            raise_version_not_found("Previous minor version for current version #{current_version}") unless ver
          end
        end

        # Previous first minor version
        #
        # @return [String]
        def fallback_minor
          return previous_fallback_version(current_major, current_minor - 1) unless current_minor.zero?

          previous_major
        end

        # Previous patch version
        #
        # @return [String]
        def previous_patch
          return fallback_patch unless tags
          return previous_minor if current_patch.zero?

          versions.find { |version| version.to_s.match?(/^#{current_major}\.#{current_minor}\.#{current_patch - 1}/) }
        end

        # Previous first patch version
        #
        # @return [String]
        def fallback_patch
          return previous_fallback_version(current_major, current_minor, current_patch - 1) unless current_patch.zero?

          previous_minor
        end

        # Version number from docker tag
        #
        # @param [String] tag
        # @return [String]
        def version(tag)
          tag.match(VERSION_PATTERN)[:version]
        end

        # Fallback version
        #
        # @param [Integer] major_component
        # @param [Integer] minor_component
        # @param [Integer] patch_component
        # @return [Gem::Version]
        def previous_fallback_version(major_component, minor_component = 0, patch_component = 0)
          Gem::Version.new("#{major_component}.#{minor_component}.#{patch_component}")
        end

        # All available gitlab versions
        #
        # @return [Array<String>]
        def versions
          @versions = tags
            .map { |tag| Gem::Version.new(tag.match(VERSION_PATTERN)[:version]) }
            .sort
            .reverse # reverse array so first match by .find always returns latest version
        end

        # All available docker tags
        #
        # @return [Array<String>]
        def tags
          return @tags if defined?(@tags)

          MAX_TAGS_HTTP_REQUESTS.times do |index|
            tag_list, more_data = fetch_tags(page: index + 1)

            if tag_list
              @tags = Array(@tags)
              @tags += tag_list
            end

            break if tag_list.nil? || more_data.nil?
          end

          @tags
        end

        def fetch_tags(page:, per_page: TAGS_PER_PAGE)
          logger.info("Fetching Docker tags page #{page} from 'gitlab/gitlab-#{edition}' registry")
          response = HttpRequest.make_http_request(
            url: "https://registry.hub.docker.com/v2/namespaces/gitlab/repositories/gitlab-#{edition}/tags?page=#{page}&page_size=#{per_page}",
            fail_on_error: false
          )

          unless response.code == 200
            logger.error("  failed to fetch docker tags - code: #{response.code}, response: '#{response.body}'")
            return nil
          end

          response = JSON.parse(response.body, symbolize_names: true)
          matching_tags = response
            .fetch(:results)
            .map { |tag| tag[:name] }
            .grep(VERSION_PATTERN)
          more_data = response.fetch(:next)

          [matching_tags, more_data]
        end

        def raise_version_not_found(error_prefix)
          raise(VersionNotFoundError, "#{error_prefix} not available on Dockerhub (yet)")
        end
      end
    end
  end
end
