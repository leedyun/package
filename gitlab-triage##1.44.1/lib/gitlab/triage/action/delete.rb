# frozen_string_literal: true

require_relative 'base'

module Gitlab
  module Triage
    module Action
      class Delete < Base
        class Dry < Delete
          def act
            puts "The following resources will be deleted by the rule **#{policy.name}**:\n\n"
            super
          end

          private

          def perform(resource)
            puts "DELETE resource with type: #{resource[:type]} and id: #{resource_id(resource)}"
          end
        end

        def act
          return unless policy.type&.to_sym == :branches

          policy.resources.each do |resource|
            perform(resource)
          end
        end

        private

        def perform(resource)
          network.delete_api(build_delete_url(resource))
        end

        def build_delete_url(resource)
          delete_url = UrlBuilders::UrlBuilder.new(
            source: policy.source,
            source_id: network.options.source_id,
            resource_type: policy.type,
            resource_id: resource_id(resource),
            network_options: network.options
          ).build

          puts Gitlab::Triage::UI.debug "delete_url: #{delete_url}" if network.options.debug

          delete_url
        end

        def resource_id(resource)
          resource[:name]
        end
      end
    end
  end
end
