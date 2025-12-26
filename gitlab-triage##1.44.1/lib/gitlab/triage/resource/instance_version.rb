# frozen_string_literal: true

require_relative 'base'

module Gitlab
  module Triage
    module Resource
      class InstanceVersion < Base
        def initialize(**options)
          super({}, **options)
        end

        def version
          response[:version]
        end

        def version_short
          version[/^\d+\.\d+/]
        end

        def revision
          response[:revision]
        end

        private

        # See https://gitlab.com/api/v4/version
        def response
          @response ||=
            network.query_api_cached(
              "#{network.options.host_url}/api/#{network.options.api_version}/version")
              .first
        end
      end
    end
  end
end
