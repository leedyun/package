# frozen_string_literal: true

require_relative 'graphql_network'
require_relative 'rest_api_network'

module Gitlab
  module Triage
    Network = Struct.new(:restapi, :graphql, keyword_init: true) do
      def query_api(url)
        restapi.query_api(url)
      end

      def query_graphql(...)
        graphql.query(...)
      end

      def query_api_cached(url)
        restapi.query_api_cached(url)
      end

      def restapi_options
        restapi.options
      end

      # FIXME: Remove the alias method
      alias_method :options, :restapi_options

      def graphql_options
        graphql.options
      end

      def post_api(...)
        restapi.post_api(...)
      end

      def delete_api(...)
        restapi.delete_api(...)
      end
    end
  end
end
