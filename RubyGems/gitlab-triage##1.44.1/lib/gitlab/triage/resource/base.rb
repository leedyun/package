# frozen_string_literal: true

require_relative '../url_builders/url_builder'

module Gitlab
  module Triage
    module Resource
      class Base
        attr_reader :resource, :parent

        CONFIDENTIAL_TEXT = '(confidential)'
        SOURCE_ERROR_MSG = 'This resource is missing project_id and group_id and unable to parse source.'

        def self.define_field(name, &block)
          define_method(name) do
            if redact_confidential_attributes?
              CONFIDENTIAL_TEXT
            else
              instance_eval(&block)
            end
          end
        end

        def initialize(
          resource, parent: nil, network: nil, redact_confidentials: true)
          @resource = resource
          @parent = parent
          @network = network
          @redact_confidentials = redact_confidentials
        end

        protected

        def redact_confidential_attributes?
          parent&.redact_confidential_attributes? ||
            (@redact_confidentials && resource[:confidential])
        end

        def network
          parent&.network || @network
        end

        private

        def expand_resource!(params: {})
          resource.merge!(
            network.query_api_cached(resource_url(params: params)).first)
        end

        def source_resource
          @source_resource ||= network.query_api_cached(source_url).first
        end

        def source_url
          build_url(options: { resource_type: nil })
        end

        def url(params = {})
          build_url(params: params)
        end

        def resource_id
          resource[:iid]
        end

        def resource_url(params: {}, sub_resource_type: nil)
          build_url(
            params: params,
            options: {
              resource_id: resource_id,
              sub_resource_type: sub_resource_type
            }
          )
        end

        def build_url(params: {}, options: {})
          UrlBuilders::UrlBuilder.new(
            url_opts
              .merge(options)
              .merge(params: { per_page: 100 }.merge(params))
          ).build
        end

        def url_opts
          {
            network_options: network.options,
            resource_type: self.class.name.demodulize.underscore.pluralize,
            source: source,
            source_id: resource[:"#{source.singularize}_id"]
          }
        end

        def source
          if resource[:project_id]
            'projects'
          elsif resource[:group_id]
            'groups'
          else
            raise ArgumentError, SOURCE_ERROR_MSG
          end
        end
      end
    end
  end
end
