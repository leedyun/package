# frozen_string_literal: false

module Gitlab
  module Triage
    module UrlBuilders
      class UrlBuilder
        def initialize(options)
          @network_options = options.fetch(:network_options)
          @host_url = @network_options.host_url
          @api_version = @network_options.api_version
          @all = options.fetch(:all, false)
          @source = options.fetch(:source, 'projects')
          @source_id = options.fetch(:source_id)
          @resource_type = options.fetch(:resource_type, nil)
          @sub_resource_type = options.fetch(:sub_resource_type, nil)
          @resource_id = options.fetch(:resource_id, nil)
          @params = options.fetch(:params, [])

          @params = @params.merge(scope: :all) if @all
        end

        def build
          url = base_url
          url << "/#{percent_encode(@resource_id.to_s)}" if @resource_id
          url << "/#{@sub_resource_type}" if @sub_resource_type
          url << params_string if @params
          url
        end

        private

        def host_with_api_url
          "#{@host_url}/api/#{@api_version}"
        end

        def base_url
          url = host_with_api_url
          url << "/#{@source}/#{percent_encode(@source_id.to_s)}" unless @all
          url << "/repository" if @resource_type == 'branches'
          url << "/#{@resource_type}" if @resource_type
          url
        end

        def params_string
          "?" << @params.map do |k, v|
            "#{percent_encode(k.to_s)}=#{percent_encode(v.to_s)}"
          end.join("&")
        end

        def percent_encode(str)
          CGI.escape(str).gsub('+', '%20')
        end
      end
    end
  end
end
